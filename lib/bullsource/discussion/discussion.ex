defmodule Bullsource.Discussion do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic, ProofReference}
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
    Repo.get(Thread,thread_id)
    |> Repo.preload(:user)
    |> Repo.preload(posts: [proofs: :article, proofs: :comment, proofs: [references: :references]])

#    proofs = Repo.all(from(pr in ProofReference, where: pr.proof_id == ^proof_id, preload: :blah))
#     thread = Thread
#     |> where([thread], thread.id == ^thread_id)
#     |> join(:left, [thread], posts in assoc(thread, :posts))
#     |> join(:left, [thread, posts], proofs in assoc(posts, :proofs))
#     |> join(:left, [thread, posts, proofs], article in assoc(proofs, :article))
#     |> join(:left, [thread, posts, proofs], comment in assoc(proofs, :comment))
#     |> join(:left, [thread, posts, proofs], references in assoc(proofs, :references))
#     |> join(:left, [thread, posts, proofs], pr in assoc(proofs, :proof_references))
#     |> preload(:user)
#     |> preload([thread, posts, proofs, article, comment, references, pr],
#          [posts: {posts, proofs:
#                    {proofs, article: article, comment: comment, pr: pr}
#                  }
#          ])
#     |> Repo.one

#    the query below works to get a nested :proof in :article
#    Repo.get(Thread,thread_id) |> Repo.preload(:user) |> Repo.preload(posts: [proofs: [article: :proof], proofs: :comment, proofs: :references])
  end

  ####creating interface functions for controllers.
  #is it possible to chain transactions at a higher order?
  #the reason for all the multis is for the rollback functionality in case anything in the chain is invalid.

  def create_thread(thread, post, user) do
    IO.puts "+++++thread:"
    IO.inspect thread
    IO.puts "+++++post:"
    IO.inspect post
    IO.puts "+++++user:"
    IO.inspect user
    case thread_transaction(thread, post, user) |> Repo.transaction do
        {:ok, %{thread: finished_thread} = new_thread} ->
          IO.puts "+++++++++++++++++++++create_thread"
          IO.inspect new_thread

          {:ok, list_posts_in_thread(finished_thread.id)}
#               finished_thread
#               |> Repo.preload(:user)
#               |> Repo.preload(posts: [proofs: :article, proofs: :comment, proofs: :references])
#              }
#        {:ok, %{thread: finished_thread} = new_thread} ->
#          IO.puts "+++++++++++++++++++++create_thread"
#          IO.inspect new_thread
#
#          query = from pr in ProofReference,
#                    where: pr.proof_id == ^new_thread.post.id and ru.user_id == ^user.id
#          {:ok,
#               finished_thread
#               |> Repo.preload(:user)
#               |> Repo.preload(posts: [proofs: :article, proofs: :comment, proofs: :references])
#          }
        {:error, _, reason, _} ->
          IO.puts "++++thread_transaction error:+++++"
          IO.inspect reason
          {:error, reason}
    end
  end

  #create_post?

  defp create_proofs(post, proofs) do
  IO.puts "create_proofs: ++++++++ post"
  IO.inspect post
  IO.puts "create_proofs: ++++++++ proofs"
  IO.inspect proofs
   case proofs_transaction(post, proofs) |> Repo.transaction do
     {:ok, proofs} -> {:ok, proofs}
     {:error, _, reason, _} -> {:error, reason}
   end
  end

  defp create_proof_details(proof, proof_content) do
    case proof_details_transaction(proof, proof_content) |> Repo.transaction do
      {:ok, post_with_proofs} ->
        IO.puts "post_with proofs: ++++++"
        IO.inspect post_with_proofs
        {:ok, post_with_proofs}

      {:error, _, reason, _} -> {:error, reason}
    end
  end

  ####Ecto.Multi functions

  def thread_transaction(thread, post, user) do
    Multi.new
    |> Multi.insert(:thread, thread_changeset(%{topic_id: thread.topic_id, user_id: user.id, title: thread.title}))
    |> Multi.run(:post,   &insert_post(&1.thread, post, user))
    |> Multi.run(:proofs, &create_proofs(&1.post, post.proofs))
    #maybe just keep pipelining the multis, and using enum.map for the proofs? I think there may be a complication because it's another Multi.new in create_proofs.
  end

  defp proofs_transaction(post, proofs) do
    Multi.new
    |> Multi.insert(:proof, proof_changeset(%{post_id: post.id}))
    |> Multi.run(:proof_chain, &insert_proofs(&1.proof, proofs))
  end

  defp proof_details_transaction(proof, proof_content) do
    Multi.new
    |> Multi.insert(:article, article_changeset(%{proof_id: proof.id, text: proof_content.article}))
    |> Multi.insert(:comment, comment_changeset(%{proof_id: proof.id, text: proof_content.comment}))
    |> Multi.insert(:reference,
      reference_changeset(%{link: proof_content.reference.link,title: proof_content.reference.title}))
    |> Multi.run(:proof_reference, &insert_proof_reference(proof, &1.reference))
  end

  defp insert_thread(thread, user) do
    thread_changeset(%{user_id: user.id, topic_id: thread.topic_id, title: thread.title})
    |> Repo.insert
  end

  defp insert_post(thread, post, user) do
    IO.puts "in insert_post, thread++++++:"
    IO.inspect thread
    IO.puts "in insert_post, post++++++:"
    IO.inspect post

    post_changeset(%{intro: post.intro, user_id: user.id, thread_id: thread.id})
    |> Repo.insert
  end

  defp insert_post_proof(post) do
    proof_changeset(%{post_id: post.id})
    |> Repo.insert
  end

#so far, post_proof will have the id of the post. We will see if there's already a link available for the reference.
  defp insert_proofs(proof, [first_proof_content | rest_proofs_content]) do

    reference = Repo.get_by(Reference, link: first_proof_content.reference.link)
    case reference do
      nil ->
      IO.puts "nil'd ++++++++++++"
        case create_proof_details(proof, first_proof_content) do
          {:ok, proof_detail} ->
            #add the previous proof details that have finished:
            #proof_details = proof_details ++ proof_detail
            insert_proofs(proof, rest_proofs_content) #recursion.

          {:error, reason} ->
            {:error, reason} #these tuples are very much DRY right now, will need refactor
        end

      reference ->
      IO.puts "reference'd+++++++++++++ #{reference}'"
#      may have to query to get the proof_id/similar to post_proof
        case create_proof_details(reference, first_proof_content) do
          {:ok, proof_detail} ->
            #add the previous proof details that have finished:
            #proof_details = proof_details ++ proof_detail
            insert_proofs(proof, rest_proofs_content) #recursion.

          {:error, reason} ->
            {:error, reason} #these tuples are very much DRY right now, will need refactor
        end
    end
  end

# recursion end here
  defp insert_proofs(proof, []) do
  #should be a query that will return a preloaded tuple.
    {:ok, proof}
  end

  defp insert_article(proof, article) do
    article_changeset(%{proof_id: post_proof.id, text: article.text}) |> Repo.insert
  end

  defp insert_comment(proof, comment) do
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
    |> validate_length(:title, max: 300)
  end

  def proof_reference_changeset(params \\ %{}) do
    %ProofReference{}
    |> cast(params, [:proof_id, :reference_id])
    |> validate_required([:proof_id, :reference_id])
    |> assoc_constraint(:proof)
    |> assoc_constraint(:reference)
  end

  def blah() do
    %Bullsource.Discussion.Thread{__meta__: #Ecto.Schema.Metadata<:loaded, "threads">,
     id: 46, inserted_at: ~N[2017-05-03 19:44:35.033274],
     posts: [%Bullsource.Discussion.Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">,
       id: 27, inserted_at: ~N[2017-05-03 19:44:35.041735],
       intro: "first thread title intro.",
       proofs: [%Bullsource.Discussion.Proof{__meta__: #Ecto.Schema.Metadata<:loaded, "proofs">,
         article: %Bullsource.Discussion.Article{__meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
          id: 14,
          proof: #Ecto.Association.NotLoaded<association :proof is not loaded>,
          proof_id: 24, text: "some blah quote from reference."},
         comment: %Bullsource.Discussion.Comment{__meta__: #Ecto.Schema.Metadata<:loaded, "comments">,
          id: 14, inserted_at: ~N[2017-05-03 19:44:35.045931],
          proof: #Ecto.Association.NotLoaded<association :proof is not loaded>,
          proof_id: 24, text: "come blah comment about article",
          updated_at: ~N[2017-05-03 19:44:35.045936]}, id: 24,
         post: #Ecto.Association.NotLoaded<association :post is not loaded>,
         post_id: 27,
         references: [%Bullsource.Discussion.Reference{__meta__: #Ecto.Schema.Metadata<:loaded, "references">,
           id: 14, link: "http://someblah.com",
           references: [%Bullsource.Discussion.Proof{__meta__: #Ecto.Schema.Metadata<:loaded, "proofs">,
             article: #Ecto.Association.NotLoaded<association :article is not loaded>,
             comment: #Ecto.Association.NotLoaded<association :comment is not loaded>,
             id: 24,
             post: #Ecto.Association.NotLoaded<association :post is not loaded>,
             post_id: 27,
             references: #Ecto.Association.NotLoaded<association :references is not loaded>}],
           title: "some blah title for the link."},
          %Bullsource.Discussion.Reference{__meta__: #Ecto.Schema.Metadata<:loaded, "references">,
           id: 15, link: "http://someblah2.com",
           references: [%Bullsource.Discussion.Proof{__meta__: #Ecto.Schema.Metadata<:loaded, "proofs">,
             article: #Ecto.Association.NotLoaded<association :article is not loaded>,
             comment: #Ecto.Association.NotLoaded<association :comment is not loaded>,
             id: 24,
             post: #Ecto.Association.NotLoaded<association :post is not loaded>,
             post_id: 27,
             references: #Ecto.Association.NotLoaded<association :references is not loaded>}],
           title: "some blah title2 for the link."}]}],
       thread: #Ecto.Association.NotLoaded<association :thread is not loaded>,
       thread_id: 46, updated_at: ~N[2017-05-03 19:44:35.041740],
       user: #Ecto.Association.NotLoaded<association :user is not loaded>,
       user_id: 1}], title: "first title thread title.",
     topic: #Ecto.Association.NotLoaded<association :topic is not loaded>,
     topic_id: 1, updated_at: ~N[2017-05-03 19:44:35.037790],
     user: %Bullsource.Accounts.User{__meta__: #Ecto.Schema.Metadata<:loaded, "users">,
      email: "blah@blah.com",
      encrypted_password: "$2b$12$RnF4AwxvGGs/SlNvMcaB.eS66hR/AWZ6WOyXiG88nWGRybaOft5M6",
      id: 1, inserted_at: ~N[2017-04-17 23:21:33.090826], password: nil,
      updated_at: ~N[2017-04-17 23:21:33.097732], username: "blah"}, user_id: 1}

  end
end