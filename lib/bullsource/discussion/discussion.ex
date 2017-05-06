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

  ####creating interface functions for controllers.

  def create_topic(params) do
    topic_changeset(params) |> Repo.insert
  end

  def create_thread(thread_params, post_params, user) do
    Repo.transaction(fn ->
      with {:ok, thread}  <- insert_thread(thread_params, user),
           {:ok, post}    <- insert_post(thread, post_params, user),
           {:ok, post_with_proofs} <- proofs_transaction(post, post_params.proofs) do
           list_posts_in_thread(thread.id)

      else
        {:error, error_changeset} ->
          IO.puts "error changeset++++++++"
          IO.inspect error_changeset
          Repo.rollback(error_changeset)
      end
    end)
  end

  defp proofs_transaction(post, [first_proof| rest_proofs] = proofs) do
    Repo.transaction(fn ->
      with {:ok, reference} <- get_or_insert_reference(first_proof.reference),
           {:ok, proof}     <- proof_changeset(%{post_id: post.id, reference_id: reference.id})    |> Repo.insert,
           {:ok, article}   <- article_changeset(%{proof_id: proof.id, text: first_proof.article}) |> Repo.insert,
           {:ok, comment}   <- comment_changeset(%{proof_id: proof.id, text: first_proof.comment}) |> Repo.insert do
           proofs_transaction(post, rest_proofs) #recursion

      else
        {:error, error_changeset} ->
          IO.puts "proofs_transaction error ++++++++"
          IO.inspect error_changeset
          Repo.rollback(error_changeset)
      end
    end)
  end

  defp proofs_transaction(post, []) do
    post |> Repo.preload(:proofs)
  end


  defp get_or_insert_reference(reference) do
    reference_check = Repo.get_by(Reference, link: reference.link)
    case reference_check do
      nil ->
        reference_changeset(%{title: reference.title,link: reference.link})
        |> Repo.insert

      reference -> {:ok, reference}
    end
  end

  defp insert_thread(thread, user) do
    thread_changeset(%{topic_id: thread.topic_id, user_id: user.id, title: thread.title})
    |> Repo.insert
  end

  defp insert_post(thread, post,user) do
    post_changeset(%{intro: post.intro, user_id: user.id, thread_id: thread.id})
    |> Repo.insert
  end

##### Changesets #####

  def topic_changeset(params \\ %{}) do
    %Topic{}
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]*$/)
    |> validate_length(:name, max: 32)
    |> validate_length(:name, min: 1)
    |> validate_length(:description, max: 140)
    |> validate_length(:description, min: 1)
    |> unique_constraint(:name)
  end

  def thread_changeset(params \\ %{}) do
    %Thread{}
    |> cast(params, [:title, :user_id, :topic_id])
    |> validate_required([:title, :user_id, :topic_id])
    |> validate_length(:title, max: 300)
    |> validate_length(:title, min: 3)
    |> assoc_constraint(:topic)
    |> assoc_constraint(:user)
  end

  def post_changeset(params \\ %{}) do
    %Post{}
    |> cast(params, [:intro, :user_id, :thread_id])
    |> validate_required([:user_id, :thread_id])
    |> validate_length(:intro, min: 3)
    |> assoc_constraint(:thread)
    |> assoc_constraint(:user)
  end

  def proof_changeset(params \\ %{}) do
    %Proof{}
    |> cast(params, [:post_id, :reference_id])
    |> validate_required([:post_id, :reference_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:reference)
  end

  #the article is a section of the reference that they're quoting.
  def article_changeset(params \\ %{}) do
    %Article{}
    |> cast(params, [:text, :proof_id])
    |> validate_required([:text, :proof_id])
    |> assoc_constraint(:proof)
  end

  def comment_changeset(params \\ %{}) do
    %Comment{}
    |> cast(params, [:text, :proof_id])
    |> validate_required([:proof_id])
    |> validate_length(:text, max: 500)
    |> assoc_constraint(:proof)
  end

  def reference_changeset(params \\ %{}) do
    %Reference{}
    |> cast(params, [:title, :link])
    |> validate_required([:link])
    |> unique_constraint(:link)
    |> validate_length(:title, max: 300)
  end


end