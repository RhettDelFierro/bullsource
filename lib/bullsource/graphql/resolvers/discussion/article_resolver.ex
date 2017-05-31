defmodule Bullsource.GraphQL.ArticleResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [edit_article: 1]
  alias Bullsource.{Repo, Discussion, Discussion.Article}

  def list(_args, _context) do
    {:ok, Repo.all(Article)}
  end

  def edit(%{article_id: article_id,text: text}, _context) do
        case edit_article(%{id: article_id, text: text}) do
          {:ok, article} -> {:ok, article}
          {:error, error_changeset} -> {:error, error_changeset}
        end

  end
end