defmodule Bullsource.GraphQL.CommentResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Comment}

  def list(_args, _context) do
    {:ok, Repo.all(Comment)}
  end

end