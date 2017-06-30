defmodule Bullsource.Discussion do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Post, Reference, Headline, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Repo
  alias Ecto.Multi

  def list_topics do
    Repo.all(Topic) |> Repo.preload(:headliness)
  end

  def list_headlines_in_topic(topic_id) do
    Repo.get(Topic,topic_id) |> Repo.preload([{:headlines, :user}])
  end

  def list_posts_in_headline(%{title: title, network: network}) do
    headline = Repo.get_by(Headline,title: title, network: network)
    case headline do

      nil ->
        []
      headline ->
        headline |> Repo.preload(posts: :references)

    end

  end

  def get_post(post_id) do
    Repo.get(Post, post_id)
    |> Repo.preload(:user)
    |> Repo.preload(:references)
  end



  ####creating interface functions for controllers/graphql.

  def create_topic(params),
    do: topic_changeset(%Topic{},params) |> Repo.insert

  def create_headline(headline_params, post_params, user) do

    Repo.transaction(fn ->
      with {:ok, headline}  <- insert_headline(headline_params),
           {:ok, post}    <- insert_post(headline, post_params, user),
           {:ok, post_with_references} <- create_post_references(post, post_params.references)
      do
        headline
      else
        {:error, error_changeset} ->
          Repo.rollback(error_changeset)
      end
    end)

  end



  def create_post(post_params, user) do
    headline = Repo.get(Headline,post_params.headline_id)

    Repo.transaction( fn -> #Repo.transaction return {:ok, ....whatever....}, the ...whatever... here is determined by the do block in the with macro.
      #can I abstract this part because of it's similarity to create_headline?
      with {:ok, post}                 <- insert_post(headline, post_params, user),
           {:ok, post_with_references} <- create_post_references(post, post_params.references)
      do
        post_with_references
      else
        {:error, error_changeset} -> Repo.rollback(error_changeset) #rollback in a Repo.transaction returns the argument in an {:error, argument} tuple. In this case {:error, error_changeset}
      end
    end)

  end



  defp create_proof_references(post, []), do: post

  defp create_post_references(post, [first_reference | rest_references] = references) do
    post = Repo.preload(post, :references)

    Repo.transaction(fn ->
      with {:ok, reference} <- get_or_insert_reference(first_reference),
           reference        <- Repo.preload(reference),
           changeset        <- Ecto.changeset.change(post) |> Ecto.changeset.put_assoc(:references, [reference]),
           {:ok, struct}    <- Repo.update(changeset)
      do
        create_post_references(post, rest_references) #recursion
      else
        {:error, error_changeset} -> Repo.rollback(error_changeset)
      end
    end)

  end



# will be more complicated because may also be references that may have been deleted or new ones added.
  def edit_post(%{id: post_id,body: body, user_id: user_id, references: references}) do
    post = Repo.get(Post,post_id)

    if post.user_id == user_id do
      changeset = post |> post_changeset(%{body: body})

      case Repo.update(changeset) do
        {:ok, post} -> {:ok, post}
        {:error, error_changeset} -> {:error, error_changeset}
      end

    else
        {:error, %{message: "this user doesn't own this post"}}
    end
  end


# if they edit the reference I want to add a new one.
  def edit_reference(%{reference: reference, post_id: post_id, user_id: user_id}) do
    post = Repo.get(Post, post_id)

    if post.user_id == user_id do
      with {:ok, reference} <- get_or_insert_reference(reference),
           changeset        =  post |> post_changeset(%{reference_id: reference.id}),
           {:ok, post}     <- Repo.update(changeset)
      do
        {:ok, reference}
      else
        {:error, error_changeset} -> {:error, error_changeset}
      end

    else
      {:error, %{message: "this user doesn't own this post"}}
    end

  end






  def get_or_insert_reference(reference) do
    reference_check = Repo.get_by(Reference, doi: reference.doi)

    case reference_check do

      nil ->
        reference_changeset(%Reference{},%{doi: reference.doi})
        |> Repo.insert

      reference ->
        {:ok, reference}

    end

  end

  defp insert_headline(headline) do
    headline_changeset(%Headline{},%{topic_id: headline.topic_id, title: headline.title, network: headline.network,
                                     url: headline.url, description: headline.description, published_at: headline.published_at})
    |> Repo.insert
  end

  defp insert_post(headline, post,user) do
    post_changeset(%Post{},%{body: post.body, user_id: user.id, headline_id: headline.id})
    |> Repo.insert!
  end






##### Changesets #####

  def topic_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]*$/)
    |> validate_length(:name, max: 32)
    |> validate_length(:name, min: 1)
    |> validate_length(:description, max: 140)
    |> validate_length(:description, min: 1)
    |> unique_constraint(:name)
  end

  def headline_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:topic_id, :title, :network, :url, :description, :published_at])
    |> validate_required([:topic_id, :title, :network, :url, :description, :published_at])
    |> validate_length(:title, max: 300)
    |> validate_length(:title, min: 3)
    |> validate_length(:description, max: 500)
    |> assoc_constraint(:topic)
  end

  def post_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:body, :user_id, :headline_id])
    |> validate_required([:user_id, :headline_id])
    |> validate_length(:body, min: 3)
    |> assoc_constraint(:headline)
    |> assoc_constraint(:user)
  end

  def reference_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:doi])
    |> validate_required([:doi])
    |> unique_constraint(:doi)

  end

end