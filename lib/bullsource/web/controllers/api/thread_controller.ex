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

  def create(conn,%{"thread" => thread}) do
    user = Guardian.Plug.current_resource(conn)

    thread_params = format_params(thread)
    IO.puts "thread_params ++++"
    IO.inspect thread_params
    post_params = Map.put(thread_params.post,:proofs,Enum.map(thread_params.post.proofs, &format_params(&1)))


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

  defp format_params(params) do

    for {key, val} <- params, into: %{} do
      cond do
        is_atom(key) -> #for keys that are already atoms

          cond do
            is_map(val) -> {key, format_params(val)}
            true -> {key, val}
          end

        true -> #for keys that are not atoms

          cond do
            is_map(val) -> {String.to_atom(key), format_params(val)}
            true -> {String.to_atom(key), val}
          end

      end
    end
  end

end