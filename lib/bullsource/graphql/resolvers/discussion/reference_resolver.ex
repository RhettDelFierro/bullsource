defmodule Bullsource.GraphQL.ReferenceResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Reference}

  def list(_args, _context) do
    {:ok, Repo.all(Reference)}
  end

  #if anything another funciton you need is:
  def get_reference_by_id(args,context) do
    {:ok, Repo.get_by(Reference,id: args.id)}
  end

end