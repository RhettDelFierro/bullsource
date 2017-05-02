defmodule Bullsource.Discussion.Reference do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof

  schema "references" do
    field :link, :string
    field :title, :string

    #has_many :proof, ProofReference
    many_to_many :references, Proof, join_through: "proof_references"

  end
end
