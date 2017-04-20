defmodule Bullsource.Web.ThreadController do
  #This is to CRUD threads (no posts yet) once a user visits a topic page.
  use Bullsource.Web, :controller

  alias Bullsource.Discussion

  def index(conn, %{"topic_ic" => topic_id}) do
    #how to get the current topic?
    threads = Discussion.list_threads_in_topic(topic_id)
    render conn, "index.json", threads: threads
  end

  def create(conn,params) do
    user = Guardian.Plug.current_resource(conn)
    IO.puts "++++++++++++ Thread :create"
    IO.inspect user

#    with {:ok, topic} <- Discussion.create_topic(topic) do
#      render conn, "show.json", topic: topic
#    end
  end
end