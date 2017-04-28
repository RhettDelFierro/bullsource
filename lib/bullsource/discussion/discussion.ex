defmodule Bullsource.Discussion do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Repo
  alias Ecto.Multi


  def list_topics do
    Repo.all(Topic) |> Repo.preload(:threads)
  end

  def create_topic(params) do
    topic_changeset(params) |> Repo.insert
  end

# will list nested threads in topics with the users who created it. I wonder if [threads: :user] works.
  def list_threads_in_topic(topic_id) do
    Repo.get(Topic,topic_id) |> Repo.preload([{:threads, :user}])
  end

  def create_thread(thread, post, user) do
    case thread_transaction(thread, post, user) |> Repo.transaction do
        {:ok, thread} -> {:ok, thread}
        {:error, _, reason, _} -> {:error, reason}
    end
  end

  def thread_transaction(thread, post, user) do
    Multi.new
    |> Multi.run(:thread, insert_thread(thread, user))
    |> Multi.run(:post,   &insert_post(&1.thread, post, user))
    |> Multi.run(:proofs, &create_proofs(&1.post, post.proofs))
  end

  defp proofs_transaction(post, proofs) do
      Multi.new
      |> Multi.run(:post_proof, insert_post_proof(post))
      |> Multi.run(:proof, &insert_proofs(&1.post_proof, proofs))
    end

  defp insert_thread(thread, user) do
    thread_changeset(%{user_id: user.id, topic_id: thread.topic_id, title: thread.title})
    |> Repo.insert
  end

  defp insert_post(thread, post, user) do
    post_changeset(%{intro: post.intro, user_id: user.id, thread_id: thread.id})
    |> Repo.insert
  end

  defp create_proofs(post, proofs) do
   case proofs_transaction(post, proofs) |> Repo.transaction do
     {:ok, post} -> {:ok, post}
     {:error, _, reason, _} -> {:error, reason}
   end
  end

  defp insert_post_proof(post) do
    proof_changeset(%{post_id: post.id})
    |> Repo.insert
  end

  defp insert_proofs(post_proof, [first_proof | rest_proofs]) do
    case Repo.get_by(Reference, link: first_proof.link) do
      nil ->
      case create_proof_details(post_proof, first_proof) do
        insert_proofs(post_proof, rest_proofs) #recursion.
      end

      reference -> reference
    end
  end

  defp insert_proofs(post, []) do
    {:ok, post |> Repo.preload(:proofs)}
  end

  defp create_proof_details(post_proof,proof) do
    case details_transaction(post_proof, proof) |> Repo.insert do
      {:ok, proof} -> proof
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  defp insert_proofs([]) do

  end

  defp insert_article(post_proof, article) do
    article_changeset(%{proof_id: post_proof.id, text: article.text}) |> Repo.insert
  end

  defp insert_comment(post_proof, comment) do
    article_changeset(%{proof_id: post_proof.id, text: comment.text}) |> Repo.insert
  end

# remember that you want to check if it exists first before you run this function.
  defp insert_reference(reference) do
    article_changeset(%{link: reference.link, title: reference.title}) |> Repo.insert
  end

  defp insert_proof_reference(post_proof, reference) do
    proof_reference_changeset(%{proof_id: post_proof.id, reference_id: reference.id})
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
    |> validate_length(:intro, max: 500)
    |> assoc_constraint(:thread)
    |> assoc_constraint(:user)
  end

  def proof_changeset(params \\ %{}) do
    %Proof{}
    |> cast(params, [:post_id])
    |> validate_required([:post_id])
    |> assoc_constraint(:post)
  end

  #the article is a section of the reference that they're quoting.
  def article_changeset(params \\ %{}) do
    %Article{}
    |> cast(params, [:text, :proof_id])
    |> validate_required([:text, :proof_id])
    |> assoc_constraint(:proof_id)
  end

  def comment_changeset(params \\ %{}) do
    %Comment{}
    |> cast(params, [:text, :proof_id])
    |> validate_required([:proof_id])
    |> validate_length(:text, max: 500)
    |> assoc_constraint(:proof_id)
  end

  def reference_changeset(params \\ %{}) do
    %Reference{}
    |> cast(params, [:title, :link, :proof_id])
    |> validate_required([:link, :proof_id])
    |> validate_length(:title, max: 300)
  end

  def proof_reference_changeset(params \\ %{}) do
    %ProofReference{}
    |> cast(params, [:proof_id, :reference_id])
    |> validate_required([:proof_id, :reference_id])
    |> assoc_constraint(:proof)
    |> assoc_constraint(:reference)
  end

end