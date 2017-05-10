defmodule Bullsource.Votes.ProofVoteUp do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof
  alias Bullsource.Accounts.User

  schema "proof_votes_up" do
    belongs_to :proof, Proof
    belongs_to :user, User

    timestamps()

  end
end