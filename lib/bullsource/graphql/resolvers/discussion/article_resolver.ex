defmodule Bullsource.GraphQL.ArticleResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [edit_article: 1]
  alias Bullsource.{Repo, Discussion.Article}



  def list(_args, _context), do: {:ok, Repo.all(Article)}




  def edit(args, %{context: %{current_user: current_user}}) do
    %{article_id: article_id,text: text} = args

    article_info =
      %{id: article_id, text: text, user_id: current_user.id}

    case edit_article(article_info) do
      {:ok, article} -> {:ok, article}
      {:error, error_changeset} -> {:error, error_changeset}
    end
  end




end