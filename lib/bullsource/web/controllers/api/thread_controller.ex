defmodule Bullsource.Web.ThreadController do
  #This is to CRUD threads (no posts yet) once a user visits a topic page.
  use Bullsource.Web, :controller

  alias Bullsource.Discussion
  alias Bullsource.Web.ErrorView


  def index(conn, %{"topic_id" => topic_id}) do
    #how to get the current topic?
    threads = Discussion.list_threads_in_topic(topic_id)
    render conn, "index.json", threads: threads
  end

  def create(conn,%{"thread" => thread} = params) do
    user = Guardian.Plug.current_resource(conn)
    %{"title" => title, "topic_id" => topic_id, "post" => post} = thread
    thread_params = %{ topic_id: topic_id, title: title}
    post_params = %{intro: post.intro, proofs: post.proofs}

    with {:ok, thread} <- Discussion.create_thread(thread_params, post_params, user) do
      render conn, "show.json", thread: thread
    else
      {:error, reason} ->
        render conn, ErrorView, "error.json", changeset_errors: reason
    end

  end

end