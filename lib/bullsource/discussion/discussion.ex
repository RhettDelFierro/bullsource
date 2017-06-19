defmodule Bullsource.Discussion do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Headline, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Repo
  alias Ecto.Multi

  def list_topics do
    Repo.all(Topic) |> Repo.preload(:headliness)
  end

  def list_headlines_in_topic(topic_id) do
    Repo.get(Topic,topic_id) |> Repo.preload([{:headliness, :user}])
  end

  def list_posts_in_headline(headline_id) do
    Repo.get(Headline,headline_id)
    |> Repo.preload(posts: [:user, :proofs, proofs: :reference, proofs: :article, proofs: :comment])
  end

  def get_post(post_id) do
    Repo.get(Post, post_id)
    |> Repo.preload(:user)
    |> Repo.preload(proofs: [:reference, :article, :comment])
  end








  ####creating interface functions for controllers/graphql.

  def create_topic(params),
    do: topic_changeset(%Topic{},params) |> Repo.insert

  def create_headline(headline_params, post_params, user) do

    Repo.transaction(fn ->
      with {:ok, headline}  <- insert_headline(headline_params),
           {:ok, post}    <- insert_post(headline, post_params, user),
           {:ok, post_with_proofs} <- create_proof_components(post, post_params.proofs)
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
      with {:ok, post}             <- insert_post(headline, post_params, user),
           {:ok, post_with_proofs} <- create_proof_components(post, post_params.proofs)
      do
        post
      else
        {:error, error_changeset} -> Repo.rollback(error_changeset) #rollback in a Repo.transaction returns the argument in an {:error, argument} tuple. In this case {:error, error_changeset}
      end
    end)

  end



  defp create_proof_components(post, []), do: post

  defp create_proof_components(post, [first_proof | rest_proofs] = proofs) do

    Repo.transaction(fn ->
      with {:ok, reference} <- get_or_insert_reference(first_proof.reference),
           {:ok, proof}     <- proof_changeset(%Proof{},%{post_id: post.id, reference_id: reference.id}) |> Repo.insert,
           {:ok, article}   <- article_changeset(%Article{},%{proof_id: proof.id, text: first_proof.article}) |> Repo.insert,
           {:ok, comment}   <- comment_changeset(%Comment{},%{proof_id: proof.id, text: first_proof.comment}) |> Repo.insert
      do
        create_proof_components(post, rest_proofs) #recursion
      else
        {:error, error_changeset} -> Repo.rollback(error_changeset)
      end
    end)

  end




  def edit_post(%{id: post_id,intro: intro, user_id: user_id}) do
    post = Repo.get(Post,post_id)

    if post.user_id == user_id do
      changeset = post |> post_changeset(%{intro: intro})

      case Repo.update(changeset) do
        {:ok, post} -> {:ok, post}
        {:error, error_changeset} -> {:error, error_changeset}
      end

    else
        {:error, %{message: "this user doesn't own this post"}}
    end
  end



  def edit_article(%{id: article_id,text: text, post_id: post_id, user_id: user_id}) do
    post = Repo.get(Post, post_id)

    if post.user_id == user_id do
      changeset =
        Repo.get(Article,article_id) |> article_changeset(%{text: text})

      case Repo.update(changeset) do
        {:ok, article} -> {:ok, article}
        {:error, error_changeset} -> {:error, error_changeset}
      end

    else
      {:error, %{message: "this user doesn't own this post"}}
    end
  end



  def edit_comment(%{id: comment_id,text: text, post_id: post_id, user_id: user_id}) do
    post = Repo.get(Post, post_id)

    if post.user_id == user_id do
      changeset =
        Repo.get(Comment,comment_id) |> comment_changeset(%{text: text})

      case Repo.update(changeset) do
        {:ok, comment} -> {:ok, comment}
        {:error, error_changeset} -> {:error, error_changeset}
      end

    else
      {:error, %{message: "this user doesn't own this post"}}
    end

  end



# if they edit the reference I want to add a new one.
  def edit_reference(%{reference: reference, proof_id: proof_id, post_id: post_id, user_id: user_id}) do
    post = Repo.get(Post, post_id)

    if post.user_id == user_id do
      with {:ok, reference} <- get_or_insert_reference(reference),
           changeset        =  Repo.get(Proof,proof_id) |> proof_changeset(%{reference_id: reference.id}),
           {:ok, proof}     <- Repo.update(changeset)
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
    reference_check = Repo.get_by(Reference, link: reference.link)

    case reference_check do

      nil ->
        reference_changeset(%Reference{},%{title: reference.title,link: reference.link})
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
    post_changeset(%Post{},%{intro: post.intro, user_id: user.id, headline_id: headline.id})
    |> Repo.insert
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
    |> cast(params, [:intro, :user_id, :headline_id])
    |> validate_required([:user_id, :headline_id])
    |> validate_length(:intro, min: 3)
    |> assoc_constraint(:headline)
    |> assoc_constraint(:user)
  end

  def proof_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:post_id, :reference_id])
    |> validate_required([:post_id, :reference_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:reference)
  end

  #the article is a section of the reference that they're quoting.
  def article_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:text, :proof_id])
    |> validate_required([:text, :proof_id])
    |> assoc_constraint(:proof)
  end

  def comment_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :proof_id])
    |> validate_required([:proof_id])
    |> validate_length(:text, max: 500)
    |> assoc_constraint(:proof)
  end

  def reference_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:title, :link])
    |> validate_required([:link])
    |> unique_constraint(:link)
    |> validate_length(:title, max: 300)
  end

end