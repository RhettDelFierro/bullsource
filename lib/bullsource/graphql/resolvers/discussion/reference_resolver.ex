defmodule Bullsource.GraphQL.ReferenceResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [edit_reference: 1]
  alias Bullsource.{Repo, Discussion.Reference}

  def list(_args, _context) do
    {:ok, Repo.all(Reference)}
  end

  #if anything another funciton you need is:
  def get_reference_by_id(args,context) do
    {:ok, Repo.get_by(Reference,id: args.id)}
  end

  def edit(%{reference: reference, proof_id: proof_id}, _context) do
    case edit_reference(%{reference: reference, proof_id: proof_id}) do
      {:ok, reference} -> {:ok, reference}
      {:error, error_changeset} -> {:error, error_changeset}
    end
  end

end