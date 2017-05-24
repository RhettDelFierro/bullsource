defmodule Bullsource.GraphQL.PostResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a Post.
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Post}

  def list(_args, _context) do
    {:ok, Repo.all(Post)}
  end

  def assoc(_args, %{source: thread} = context) do
    #now we're only making one query for all the Posts int he topic:
    batch {__MODULE__, :by_thread_id}, thread.id, fn results ->
        {:ok, Map.get(results, thread.id)}
    end
#    topic = Repo.preload(topic, :Posts)
#    {:ok, topic.Posts}
  end

  def create(%{thread_id: thread_id, post: post} = args, %{context: %{current_user: current_user}}) do
     post_params = Map.put_new(post, :thread_id, thread_id)
     with {:ok, post} <- Discussion.create_post(post_params, current_user)
     do
       {:ok, post}
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