defmodule Bullsource.GraphQL.PostResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a Post.
  import Ecto.Query

  alias Bullsource.{Repo, Discussion.Post}

  def list(_args, _context) do
    {:ok, Repo.all(Post)}
  end

  def assoc(_args, %{source: thread} = context) do
    #now we're only making one query for all the Posts int he topic:
    batch {__MODULE__, :by_topic_id}, thread.id, fn results ->
        {:ok, Map.get(results, thread.id)}
    end
#    topic = Repo.preload(topic, :Posts)
#    {:ok, topic.Posts}
  end

  def create(%{intro: intro, topic_id: thread_id}, _context) do
    post = Repo.insert! %Post{intro: intro, thread_id: thread_id}
    {:ok, post}
  end

  def by_topic_id(_, ids) do
    Post
    |> where([t], t.thread_id in ^ids)
    |> Repo.all
    |> Enum.group_by(&(&1.thread_id))
  end
end