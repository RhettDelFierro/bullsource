defmodule Bullsource.Web.PostController do
  #This is to CRUD threads (no posts yet) once a user visits a topic page.
  use Bullsource.Web, :controller

  alias Bullsource.Discussion
  alias Bullsource.Web.ErrorView
  alias Bullsource.Helpers.Converters

# when a user visits the thread, show all posts.
  def index(conn, %{"thread_id" => thread_id}) do
    #how to get the current topic?
    posts = Discussion.list_posts_in_thread(thread_id)
    render conn, "index.json", posts: posts
  end
# json will ome in as {intro: string, thread_id: id, proofs: [proofs]}
  def create(conn,%{"post" => post}) do
    user = Guardian.Plug.current_resource(conn)

    #body has the proofs, which consist of article, comment and reference.
    #proofs will come in as a list.
    %{"thread_id" => thread_id, "proofs" => proofs, "intro" => intro} = post
    post = %{user_id: user.id,
             thread_id: thread_id,
             intro: intro,
             proofs: proofs
           }

    post_params = Converters.str_to_atom_keys(post)
    post_params = %{post_params | proofs: Enum.map(post_params.proofs, &Converters.str_to_atom_keys(&1))}

    with {:ok, thread} <- Discussion.create_post(post_params, user) do
      render conn, "show.json", thread: thread
    else
      {:error, error_changeset} ->
        render conn, ErrorView, "error.json", changeset_errors: error_changeset
    end

  end

end