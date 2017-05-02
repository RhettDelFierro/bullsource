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

    %{"title" => title, "topic_id" => topic_id, "post" => post} = thread
    %{"intro" => intro, "proofs" => proofs} = post
    thread_params = %{ topic_id: topic_id, title: title}
    proofs = Enum.map proofs, fn proof ->
      %{"article" => article, "comment" => comment, "reference" => reference} = proof
      %{"link" => link, "title" => reference_title} = reference
      %{
        article: article,
        comment: comment,
        reference: %{link: link, title: reference_title}
      }
      end
    post_params = %{intro: intro, proofs: proofs}

    with {:ok, new_thread} <- Discussion.create_thread(thread_params, post_params, user) do
      IO.puts "back in controller, here is thread:++++++"
      IO.inspect new_thread
      render conn, "show.json", new_thread: new_thread
    else
      {:error, reason} ->
        render conn, ErrorView, "error.json", changeset_errors: reason
    end

  end

end