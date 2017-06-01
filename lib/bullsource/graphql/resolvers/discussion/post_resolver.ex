defmodule Bullsource.GraphQL.PostResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [create_post: 2, edit_post: 1]
  alias Bullsource.{Repo, Discussion.Post}


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

  def edit(%{post_id: post_id,intro: intro},%{context: %{current_user: current_user}}) do
    case edit_post(%{id: post_id, intro: intro, user_id: current_user.id}) do
      {:ok, post} -> {:ok, post}
      {:error, error} -> {:error, error}
    end
  end

end