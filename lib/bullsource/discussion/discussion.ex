defmodule Bullsource.Discussion do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Repo
  alias Ecto.Multi

  def list_topics do
    Repo.all(Topic) |> Repo.preload(:threads)
  end

  def list_threads_in_topic(topic_id) do
    Repo.get(Topic,topic_id) |> Repo.preload([{:threads, :user}])
  end

  def list_posts_in_thread(thread_id) do
    Repo.get(Thread,thread_id)
    |> Repo.preload(:user)
    |> Repo.preload(posts: [:user, :proofs, proofs: :reference, proofs: :article, proofs: :comment])
  end

  def get_post(post_id) do
    Repo.get(Post, post_id)
    |> Repo.preload(:user)
    |> Repo.preload(proofs: [:reference, :article, :comment])
  end

  ####creating interface functions for controllers.

  def create_topic(params) do
    topic_changeset(%Topic{},params) |> Repo.insert
  end

  def create_thread(thread_params, post_params, user) do
    Repo.transaction(fn ->
      with {:ok, thread}  <- insert_thread(thread_params, user),
           {:ok, post}    <- insert_post(thread, post_params, user),
           {:ok, post_with_proofs} <- proofs_transaction(post, post_params.proofs)
      do
         #for graphQL
         thread
      else
        {:error, error_changeset} -> Repo.rollback(error_changeset)
      end
    end)
  end

  def create_post(post_params, user) do
    thread = Repo.get(Thread,post_params.thread_id)
    Repo.transaction( fn -> #Repo.transaction return {:ok, ....whatever....}, the ...whatever... here is determined by the do block in the with macro.
      #can I abstract this part because of it's similarity to create_thread?
      with {:ok, post} <- insert_post(thread, post_params, user),
           {:ok, post_with_proofs} <- proofs_transaction(post, post_params.proofs)
      do
        post
      else
        {:error, error_changeset} -> Repo.rollback(error_changeset) #rollback in a Repo.transaction returns the argument in an {:error, argument} tuple. In this case {:error, error_changeset}
      end

    end)
  end

  def edit_post(post_params, user) do
    post = Repo.get(Post,post_params.id)
    post_params = Map.put_new(post_params, :thread_id, post.thread_id)
    with {:ok, post} <- post_changeset(post, post_params),
         {:ok, post} <- Repo.update post
    do
      {:ok, post}
    else
      {:error, error_changeset} -> {:error, error_changeset}
    end
  end

  def edit_proofs([first_proof | rest_proofs], user) do

  end

  def edit_proofs([], user), do: user

  defp proofs_transaction(post, [first_proof | rest_proofs] = proofs) do
    Repo.transaction(fn ->
#    possible to do this part with a Multi or concurrently when you get the reference?
      with {:ok, reference} <- get_or_insert_reference(first_proof.reference),
           {:ok, proof}     <- proof_changeset(%Proof{},%{post_id: post.id, reference_id: reference.id})    |> Repo.insert,
           {:ok, article}   <- article_changeset(%Article{},%{proof_id: proof.id, text: first_proof.article}) |> Repo.insert,
           {:ok, comment}   <- comment_changeset(%Comment{},%{proof_id: proof.id, text: first_proof.comment}) |> Repo.insert
      do
        proofs_transaction(post, rest_proofs) #recursion
      else
        {:error, error_changeset} -> Repo.rollback(error_changeset)
      end
    end)
  end

  defp proofs_transaction(post, []), do: post

  def get_or_insert_reference(reference) do
    reference_check = Repo.get_by(Reference, link: reference.link)
    case reference_check do
      nil ->
        reference_changeset(%Reference{},%{title: reference.title,link: reference.link})
        |> Repo.insert

      reference -> {:ok, reference}
    end
  end

  defp insert_thread(thread, user) do
    thread_changeset(%Thread{},%{topic_id: thread.topic_id, user_id: user.id, title: thread.title})
    |> Repo.insert
  end

  defp insert_post(thread, post,user) do
    post_changeset(%Post{},%{intro: post.intro, user_id: user.id, thread_id: thread.id})
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

  def thread_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:title, :user_id, :topic_id])
    |> validate_required([:title, :user_id, :topic_id])
    |> validate_length(:title, max: 300)
    |> validate_length(:title, min: 3)
    |> assoc_constraint(:topic)
    |> assoc_constraint(:user)
  end

  def post_changeset(struct,params \\ %{}) do
    struct
    |> cast(params, [:intro, :user_id, :thread_id])
    |> validate_required([:user_id, :thread_id])
    |> validate_length(:intro, min: 3)
    |> assoc_constraint(:thread)
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