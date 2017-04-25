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

# will list nested threads in topics with the users who created it. I wonder if [threads: :user] works.
  def list_threads_in_topic(topic_id) do
    Repo.get(Topic,topic_id) |> Repo.preload([{:threads, :user}])
  end


  def create_thread(params) do
    thread_changeset(params) |> Repo.insert
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
   #maybe split it here: the post stuff is handled seaparately from the proof stuff. Use a with macro in the controller? because you need the post id. But what if the proof is invalid - you don't want to store the post in the database. Maybe use a transaction?
  def create_post(params) do
    with {:ok, post}       <- post_changeset(params) |> Repo.insert
            proof_params = %{post_id: post.id}
         {:ok, proof_info} <- proof_changeset(proof_params) |> Repo.insert do
            proof_id = proof_info.id
            #now you have both post and proof ids for associations to articles, comments and references.
         {:ok, }

    else {:error, error_changeset} ->
           {:error, error_changeset}
    end

  end


  #should I check to see if it's a new thread starter? If it's a thread starting post, it'll be a little different. I guess that'll be decided in Thread's logic. -
  def post_changeset(params \\%{}) do
    %Post{}
    |> cast(params, [:intro, :user_id, :thread_id])
    |> validate_required([:user_id, :thread_id])
    |> validate_length(:intro, min: 3)
    |> validate_length(:intro, max: 500)
    |> assoc_constraint(:thread)
    |> assoc_constraint(:user)
  end

  def proof_changeset(params \\%{}) do
    %Proof{}
    |> cast(params, [:post_id])
    |> validate_required([:post_id])
    |> assoc_constraint(:post)
  end

  def store_proofs(proofs) do
    Enum.map()
  end

  #the article is a section of the reference that they're quoting.
  def article_changeset(params \\%{}) do
    %Article{}
    |> cast(params, [:text, :proof_id])
    |> validate_required([:text, :proof_id])
    |> assoc_constraint(:proof_id)
  end

  def comment_changeset(params \\%{}) do
    %Comment{}
    |> cast(params, [:text, :proof_id])
    |> validate_required([:proof_id])
    |> validate_length(:text, max: 500)
    |> assoc_constraint(:proof_id)
  end

  def reference_changeset(params \\%{}) do
    %Reference{}
    |> cast(params, [:title, :link, :proof_id])
    |> validate_required([:link, :proof_id])
    |> validate_length(:title, max: 300)
    |> assoc_constraint(:proof_id)
  end

end