defmodule Bullsource.Discussion do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Repo


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

  def create_thread(%{thread_param: thread_param, post_param: post_param} = params) do
    case insert_thread(thread_param) do
      {:ok, thread} ->
        case create_post(%{post_param | thread_id: thread.id}) do
          {:ok, post} -> {:ok, post}
          {:error, error_changeset} -> {:error, error_changeset}
        end

      {:error, error_changeset} ->
        {:error, error_changeset}
    end
  end

   #maybe split it here: the post stuff is handled seaparately from the proof stuff. Use a with macro in the controller? because you need the post id. But what if the proof is invalid - you don't want to store the post in the database. Maybe use a transaction?
  def create_post(%{thread_id: thread_id, user_id: user_id, intro: intro, proofs: proofs} = params) do
    post_info = %{thread_id: thread_id, user_id: user_id, intro: intro}
    case insert_post(post_info) do
      {:ok, post} ->
#        proofs_with_post_id = Enum.map proofs, &Map.put_new(&1, :post_id, post.id)
        #fix this
        case insert_proofs(post, proofs_with_post_id) do
        {:ok, blah} -> IO.puts "blah"
        _ -> IO.puts "haha"
        end
      {:error, error_changeset} ->
        {:error, error_changeset}
    end
  end

  defp insert_thread(params) do
    thread_changeset(params) |> Repo.insert
  end

  defp insert_post(params) do
    post_changeset(params) |> Repo.insert
  end

  defp insert_proofs(post, [first_proof | rest_proof]) do
    case insert_proof(%{first_proof | post_id: post.id}) do
      {:ok, proof} ->
        article   = article_changeset(%{text: first_proof.article.text, proof_id: proof.id}) #maybe have a reference id?
        comment   = comment_changeset(%{text: first_proof.comment.text, proof_id: proof.id})
        reference = reference_changeset(%{link: first_proof.reference.link, title: first_proof.reference.title})
        Repo.transaction

#        handle this when you get back the reference id.
        proof_reference = %{}
        # can add article, comment and referencewith the proof_id:
        #use Repo.transaction with the proof_id.



        #recursion:
        insert_proofs(rest_proof)
      {:error, error_changeset} ->
        {:error, error_changeset}
    end
  end

  defp insert_proofs([]) do

  end

  defp insert_proof(%{post_id: post_id, article: article, comment: comment, reference: reference}) do
    proof_changeset(%{post_id: post_id}) |> Repo.insert
  end

  defp insert_article(params) do
    article_changeset(params) |> Repo.insert
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