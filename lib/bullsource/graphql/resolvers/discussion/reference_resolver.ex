defmodule Bullsource.GraphQL.ReferenceResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [edit_reference: 1]
  alias Bullsource.{Repo, Discussion.Reference}

  def list(_args, _context), do: {:ok, Repo.all(Reference)}



  #if anything another funciton you need is:
  def get_reference_by_id(args,context), do: {:ok, Repo.get_by(Reference,id: args.id)}




  def edit(args, _context) do
    %{reference: reference, proof_id: proof_id} = args
    reference_info = %{reference: reference, proof_id: proof_id}

    case edit_reference(reference_info) do
      {:ok, reference} -> {:ok, reference}
      {:error, error_changeset} -> {:error, error_changeset}
    end

  end


end