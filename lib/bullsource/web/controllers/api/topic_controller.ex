defmodule Bullsource.Web.TopicController do
  use Bullsource.Web, :controller

  alias Bullsource.Discussion

  def index(conn, _params) do
    topics = Discussion.list_topics()
    render conn, "index.json", topics: topics
  end

  def create(conn, %{"name" => name, "description" => description}) do
    topic = %{name: name, description: description}

    #you have not yet handled the case where create_topic fails.
    with {:ok, topic} <- Discussion.create_topic(topic) do
      render conn, "show.json", topic: topic
    end
  end
end