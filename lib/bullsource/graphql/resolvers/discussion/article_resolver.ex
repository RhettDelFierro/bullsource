defmodule Bullsource.GraphQL.ArticleResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Article}

  def list(_args, _context) do
    {:ok, Repo.all(Article)}
  end
end