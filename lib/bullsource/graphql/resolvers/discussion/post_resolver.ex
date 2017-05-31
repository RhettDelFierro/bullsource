defmodule Bullsource.GraphQL.PostResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Post}
  import Discussion, only: [create_post: 2, edit_post: 2]

  def list(_args, _context) do
    {:ok, Repo.all(Post)}
  end

  def create(%{thread_id: thread_id, post: post}, %{context: %{current_user: current_user}}) do
     post_params = Map.put_new(post, :thread_id, thread_id)
     with {:ok, post} <- create_post(post_params, current_user)
     do
       {:ok, post}
     else
       {:error, errors} -> {:error, errors}
     end
  end

  def edit(%{post_id: post_id, edited_post: edited_post},%{context: %{current_user: current_user}}) do
    post_params = %{id: post_id}
#    go through edited_post, if the the fields are not blank, add them to a map.
#%{id: post_id, intro: intro, proofs: proofs} -----> was the first argument to edit_post
    with {:ok, post} <- edit_post(post_params, current_user)
    do
      {:ok, post}
    else
      {:error, errors} -> {:error, errors}
    end
  end

end