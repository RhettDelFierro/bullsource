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

  def list_posts_in_thread(thread_id) do
#    thread = Repo.get(Thread,thread_id)
#    |> Repo.preload(:user)
#    |> Repo.preload(posts: [proofs: :article, proofs: :comment])


    Repo.get(Thread,thread_id)
    |> Repo.preload(:user)
    |> Repo.preload(posts: [:proofs, proofs: :reference, proofs: :article, proofs: :comment])

#    thread = Thread
#    |> where([thread], thread.id == ^thread_id)
#    |> join(:left, [thread], posts in assoc(thread, :posts))
#    |> join(:left, [thread, posts], proofs in assoc(posts, :proofs))
##    |> join(:left, [thread,posts,proofs], article in assoc(proofs, :article))
##    |> join(:left, [thread,posts,proofs], comment in assoc(proofs, :article))
#    |> Repo.preload([{:threads, :posts}])
#    |> Repo.one
  end

  ####creating interface functions for controllers.
  #is it possible to chain transactions at a higher order?
  #the reason for all the multis is for the rollback functionality in case anything in the chain is invalid.

  def create_thread(thread, post, user) do
    Repo.transaction(fn ->
      with {:ok, post_insert} <- thread_transaction(thread, post, user),
           {:ok, post_with_proofs} <- proofs_transaction(post_insert,post.proofs) do
           IO.puts "post_with_proofs +++++++"
           IO.inspect post_with_proofs
           post_with_proofs

      else
        {:error, error_changeset} ->
          IO.puts "error changeset++++++++"
          IO.inspect error_changeset
          Repo.rollback(error_changeset)
      end
    end)
  end

  def thread_transaction(thread, post, user) do
    Repo.transaction(fn ->
      with {:ok, thread_insert} <- thread_changeset(%{topic_id: thread.topic_id, user_id: user.id, title: thread.title}) |> Repo.insert,
           {:ok, post_insert} <- post_changeset(%{intro: post.intro, user_id: user.id, thread_id: thread_insert.id}) |> Repo.insert do
           post_insert
      else
        {:error, error_changeset} ->
          IO.puts "thread_transaction error ++++++++"
          IO.inspect error_changeset
          Repo.rollback(error_changeset)
      end
    end)
  end

  defp proofs_transaction(post, [first_proof| rest_proofs]) do
    Repo.transaction(fn ->
      with {:ok, reference} <- get_or_insert_reference(first_proof.reference),
           {:ok, proof} <- proof_changeset(%{post_id: post.id, reference_id: reference.id}) |> Repo.insert,
           {:ok, article} <- article_changeset(%{proof_id: proof.id, text: first_proof.article}) |> Repo.insert,
           {:ok, comment} <- comment_changeset(%{proof_id: proof.id, text: first_proof.comment}) |> Repo.insert do
           proofs_transaction(post, rest_proofs)
      else
        {:error, error_changeset} ->
          IO.puts "proofs_transaction error ++++++++"
          IO.inspect error_changeset
          Repo.rollback(error_changeset)
      end
    end)
  end

  defp proofs_transaction(post, []) do
    IO.puts "+++proofs_transaction wiht [] ++++++"
    IO.inspect post
    post |> Repo.preload(:proofs)
  end


  defp get_or_insert_reference(reference) do
    reference_check = Repo.get_by(Reference, link: reference.link)
    case reference_check do
      nil ->
        reference_changeset(%{title: reference.title,link: reference.link}) |> Repo.insert
      reference ->
        {:ok, reference}
    end
  end

  defp insert_proofs() do

  end

  defp insert_proof_details(proof, proof_content) do
    Multi.new
    |> Multi.insert(:article, article_changeset(%{proof_id: proof.id, text: proof_content.article}))
    |> Multi.insert(:comment, comment_changeset(%{proof_id: proof.id, text: proof_content.comment}))
  end

  defp insert_post(thread, post, user) do
    post_changeset(%{intro: post.intro, user_id: user.id, thread_id: thread.id})
    |> Repo.insert
  end
  
#so far, post_proof will have the id of the post. We will see if there's already a link available for the reference.
  defp insert_proof(post, proof_content, reference) do
   Multi.new
   |> Multi.insert(:proof, proof_changeset(%{post_id: post.id, reference_id: reference.id}))
   |> Multi.run(:proof_chain, &insert_proof_details(&1.proof, proof_content))
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

#  def blah() do
#    %Bullsource.Discussion.Thread{__meta__: #Ecto.Schema.Metadata<:loaded, "threads">,
#     id: 46, inserted_at: ~N[2017-05-03 19:44:35.033274],
#     posts: [%Bullsource.Discussion.Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">,
#       id: 27, inserted_at: ~N[2017-05-03 19:44:35.041735],
#       intro: "first thread title intro.",
#       proofs: [%Bullsource.Discussion.Proof{__meta__: #Ecto.Schema.Metadata<:loaded, "proofs">,
#         article: %Bullsource.Discussion.Article{__meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
#          id: 14,
#          proof: #Ecto.Association.NotLoaded<association :proof is not loaded>,
#          proof_id: 24, text: "some blah quote from reference."},
#         comment: %Bullsource.Discussion.Comment{__meta__: #Ecto.Schema.Metadata<:loaded, "comments">,
#          id: 14, inserted_at: ~N[2017-05-03 19:44:35.045931],
#          proof: #Ecto.Association.NotLoaded<association :proof is not loaded>,
#          proof_id: 24, text: "come blah comment about article",
#          updated_at: ~N[2017-05-03 19:44:35.045936]}, id: 24,
#         post: #Ecto.Association.NotLoaded<association :post is not loaded>,
#         post_id: 27,
#         references: [%Bullsource.Discussion.Reference{__meta__: #Ecto.Schema.Metadata<:loaded, "references">,
#           id: 14, link: "http://someblah.com",
#           references: [%Bullsource.Discussion.Proof{__meta__: #Ecto.Schema.Metadata<:loaded, "proofs">,
#             article: #Ecto.Association.NotLoaded<association :article is not loaded>,
#             comment: #Ecto.Association.NotLoaded<association :comment is not loaded>,
#             id: 24,
#             post: #Ecto.Association.NotLoaded<association :post is not loaded>,
#             post_id: 27,
#             references: #Ecto.Association.NotLoaded<association :references is not loaded>}],
#           title: "some blah title for the link."},
#          %Bullsource.Discussion.Reference{__meta__: #Ecto.Schema.Metadata<:loaded, "references">,
#           id: 15, link: "http://someblah2.com",
#           references: [%Bullsource.Discussion.Proof{__meta__: #Ecto.Schema.Metadata<:loaded, "proofs">,
#             article: #Ecto.Association.NotLoaded<association :article is not loaded>,
#             comment: #Ecto.Association.NotLoaded<association :comment is not loaded>,
#             id: 24,
#             post: #Ecto.Association.NotLoaded<association :post is not loaded>,
#             post_id: 27,
#             references: #Ecto.Association.NotLoaded<association :references is not loaded>}],
#           title: "some blah title2 for the link."}]}],
#       thread: #Ecto.Association.NotLoaded<association :thread is not loaded>,
#       thread_id: 46, updated_at: ~N[2017-05-03 19:44:35.041740],
#       user: #Ecto.Association.NotLoaded<association :user is not loaded>,
#       user_id: 1}], title: "first title thread title.",
#     topic: #Ecto.Association.NotLoaded<association :topic is not loaded>,
#     topic_id: 1, updated_at: ~N[2017-05-03 19:44:35.037790],
#     user: %Bullsource.Accounts.User{__meta__: #Ecto.Schema.Metadata<:loaded, "users">,
#      email: "blah@blah.com",
#      encrypted_password: "$2b$12$RnF4AwxvGGs/SlNvMcaB.eS66hR/AWZ6WOyXiG88nWGRybaOft5M6",
#      id: 1, inserted_at: ~N[2017-04-17 23:21:33.090826], password: nil,
#      updated_at: ~N[2017-04-17 23:21:33.097732], username: "blah"}, user_id: 1}
#
#  end
end