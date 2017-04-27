defmodule Bullsource.Discussion.ProofReference do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof
  alias Bullsource.Discussion.Reference

  schema "proof_references" do
    belongs_to :proof, Proof
    belongs_to :reference, Reference

    timestamps()
  end

end
