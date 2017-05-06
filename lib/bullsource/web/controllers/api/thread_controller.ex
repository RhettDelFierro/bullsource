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
    post_params = format_params(thread_params.post)


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

  defp format_params({key,val} = params) do
    for {key, val} <- params, into: %{} do
      cond do
        is_atom(key) ->
          new_val = format_params(val)
          {key, new_val}
        true ->
          new_val = format_params(val)
          {String.to_atom(key), new_val}
      end
    end
  end

  defp format_params(val) do
    val
  end

  defp format_thread(thread) do
    %{"title" => title, "topic_id" => topic_id, "post" => post} = thread
    %{"intro" => intro, "proofs" => proofs} = post

    thread_params = %{ topic_id: topic_id, title: title}

    proofs = format_proofs(proofs)

    post_params = %{intro: intro, proofs: proofs}

    {thread_params, post_params}
  end

  defp format_proofs(proofs) do
   Enum.map proofs, fn proof ->
      %{"article" => article, "comment" => comment, "reference" => reference} = proof
      %{"link" => link, "title" => reference_title} = reference
      %{
        article: article,
        comment: comment,
        reference: %{link: link, title: reference_title}
      }
   end

  end

end