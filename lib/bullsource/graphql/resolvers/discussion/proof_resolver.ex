defmodule Bullsource.GraphQL.ProofResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Proof}

  def list(_args, _context) do
    {:ok, Repo.all(Proof)}
  end

end