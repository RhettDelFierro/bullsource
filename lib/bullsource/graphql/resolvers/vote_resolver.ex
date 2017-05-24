defmodule Bullsource.GraphQL.VoteResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a Post.
  import Ecto.Query

  alias Bullsource.{Repo, Votes, Discussion.Post}

  def list(_args, _context) do
    {:ok, Repo.all(Post)}
  end

# vote object will either be post, proof or reference - for now.
  def assoc(_args, %{source: vote_object} = context) do
    #now we're only making one query for all the Posts int he topic:
    batch {__MODULE__, :by_thread_id}, vote_object.id, fn results ->
        {:ok, Map.get(results, vote_object.id)}
    end
#    topic = Repo.preload(topic, :Posts)
#    {:ok, topic.Posts}
  end

# maybe: %{vote_object: vote_object} = params, %{context: %{current_user: current_user) - the client will decide the vote object.
# maybe a wrapper function around the vote mutation that returns a resolve function?
  def create(%{thread_id: thread_id, post: post} = params, %{context: %{current_user: current_user}}) do
     post_params = Map.put_new(post, :thread_id, thread_id)
     with {:ok, posts} <- Votes.create_vote(post_params, current_user)
     do
       {:ok, posts}
     else
       {:error, errors} -> {:error, errors}
     end
  end

# ids are thread_ids
  def by_thread_id(_, ids) do
    Post
    |> where([p], p.thread_id in ^ids)
    |> Repo.all
    |> Enum.group_by(&(&1.thread_id))
  end
end