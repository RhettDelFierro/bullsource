defmodule Bullsource.GraphQL.CommentResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [edit_comment: 1]
  alias Bullsource.{Repo, Discussion, Discussion.Comment}

  def list(_args, _context) do
    {:ok, Repo.all(Comment)}
  end

  def edit(%{comment_id: comment_id,text: text}, _context) do
        case edit_comment(%{id: comment_id, text: text}) do
          {:ok, comment} -> {:ok, comment}
          {:error, error_changeset} -> {:error, error_changeset}
        end
  end

end