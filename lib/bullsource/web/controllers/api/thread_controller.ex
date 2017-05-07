defmodule Bullsource.Web.ThreadController do
  #This is to CRUD threads (no posts yet) once a user visits a topic page.
  use Bullsource.Web, :controller

  alias Bullsource.Discussion
  alias Bullsource.Web.ErrorView
  alias Bullsource.Helpers.Converters


  def index(conn, %{"topic_id" => topic_id}) do
    #how to get the current topic?
    threads = Discussion.list_threads_in_topic(topic_id)
    render conn, "index.json", threads: threads
  end

  def create(conn,%{"thread" => thread}) do
    user = Guardian.Plug.current_resource(conn)

    thread_params = Converters.str_to_atom_keys(thread)
    post_params = Map.put(thread_params.post, :proofs,
                           Enum.map(thread_params.post.proofs, &Converters.str_to_atom_keys(&1))
                         )


    with {:ok, new_thread} <- Discussion.create_thread(thread_params, post_params, user) do
      IO.puts "back in thread controller create/2, here is new_thread:++++++"
      IO.inspect new_thread
      render conn, "show.json", new_thread: new_thread
    else
      {:error, reason} ->
        IO.puts "thread controller create/2 error changeset+++++++++"
        IO.inspect reason
        render conn, ErrorView, "error.json", changeset_error: reason
    end

  end

end