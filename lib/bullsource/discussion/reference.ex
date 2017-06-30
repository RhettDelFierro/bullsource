defmodule Bullsource.Discussion.Reference do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof
  alias Bullsource.Votes.{ReferenceVoteUp, ReferenceVoteDown}

  schema "references" do
    field :doi, :string, unique: true
    field :title, :string

    #has_many :proof, ProofReference
    has_many :proofs, Proof
    has_many :reference_votes_down, ReferenceVoteDown
    has_many :reference_votes_up, ReferenceVoteUp

  end
end
