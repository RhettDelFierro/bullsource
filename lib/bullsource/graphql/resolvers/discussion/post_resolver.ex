defmodule Bullsource.GraphQL.PostResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Post}
  import Discussion, only: [create_post: 2, edit_post: 1]

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
    case edit_post(%{id: post_id, intro: intro}) do
      {:ok, post} -> {:ok, post}
      {:error, error_changeset} -> {:error, error_changeset}
    end
  end

end