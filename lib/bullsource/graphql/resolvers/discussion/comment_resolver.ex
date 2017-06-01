defmodule Bullsource.GraphQL.CommentResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [edit_comment: 1]
  alias Bullsource.{Repo, Discussion.Comment}

  def list(_args, _context) do
    {:ok, Repo.all(Comment)}
  end

  def edit(%{comment_id: comment_id,text: text, post_id: post_id}, %{context: %{current_user: current_user}}) do
        case edit_comment(%{id: comment_id, text: text, post_id: post_id, user_id: current_user.id}) do
          {:ok, comment} -> {:ok, comment}
          {:error, error} -> {:error, error}
        end
  end

end