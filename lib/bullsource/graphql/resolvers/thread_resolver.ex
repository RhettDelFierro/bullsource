defmodule Bullsource.GraqphQL.ThreadResolver do
  alias Bullsource.Repo
  alias Bullsource.Discussion.Thread

  def assoc(_args, %{source: topic}) do
    topic = Repo.preload(topic, :threads)
    {:ok, topic.threads}
  end

  def create(%{title: title, topic_id: topic_id}, _context) do
    thread = Repo.insert! %Thread{title: title, topic_id: topic_id}
    {:ok, thread}
  end

end