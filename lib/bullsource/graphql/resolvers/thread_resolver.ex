defmodule Bullsource.GraqphQL.ThreadResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a thread.
  import Ecto.Query

  alias Bullsource.{Repo, Discussion.Thread}

  def assoc(_args, %{source: topic}) do
    #now we're only making one query for all the threads int he topic:
    batch {__MODULE__, :by_topic_id}, topic.id, fn results ->
        {:ok, Map.get(results, topic.id)}
    end
#    topic = Repo.preload(topic, :threads)
#    {:ok, topic.threads}
  end

  def create(%{title: title, topic_id: topic_id}, _context) do
    thread = Repo.insert! %Thread{title: title, topic_id: topic_id}
    {:ok, thread}
  end

  def by_topic_id(_, ids) do
    Thread
    |> where([t], t.topic_id in ^ids)
    |> Repo.all
    |> Enum.group_by(&(&1.topic_id))
  end
end