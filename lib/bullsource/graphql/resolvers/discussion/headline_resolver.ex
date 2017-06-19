defmodule Bullsource.GraphQL.HeadlineResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion.Headline}
  import Bullsource.Discussion, only: [create_headline: 3]

# should give the topic id (the category id) and get headlines associated with it.
  def list(_args, _context) do
    {:ok, Repo.all(Headline)}
  end

  def create(args, %{context: %{current_user: current_user}} = context) do
    {post_params,headline_params} = Map.pop(args, :post)
    with {:ok, headline} <- create_headline(headline_params, post_params, current_user)
    do
      {:ok, headline}
    else
       {:error, errors} -> {:error, errors}
    end
  end


end