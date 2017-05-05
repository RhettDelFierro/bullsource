defmodule Bullsource.Discussion.Reference do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof

  schema "references" do
    field :link, :string, unique: true
    field :title, :string

    #has_many :proof, ProofReference
    has_many :proofs, Proof

  end
end
