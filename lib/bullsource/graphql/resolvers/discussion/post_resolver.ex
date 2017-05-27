defmodule Bullsource.GraphQL.PostResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Post}
  import Discussion, only: [create_post: 2]

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

  def update(%{post_id: post_id},%{context: %{current_user: current_user}}) do

  end

end