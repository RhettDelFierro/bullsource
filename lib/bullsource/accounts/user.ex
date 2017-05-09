defmodule Bullsource.Accounts.User do
  use Ecto.Schema

  alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                          ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}
  alias Bullsource.Discussion.{Post, Thread}

  schema "users" do

    field :username, :string, unique: true
    field :email, :string, unique: true
    field :encrypted_password, :string
    field :password, :string, virtual: true

    has_many :posts, Post
    has_many :threads, Thread
    has_many :post_votes_down, PostVoteDown
    has_many :post_votes_up, PostVoteUp
    has_many :proof_votes_down, ProofVoteDown
    has_many :proof_votes_up, ProofVoteUp
    has_many :reference_votes_down, ReferenceVoteDown
    has_many :reference_votes_up, ReferenceVoteUp

    timestamps()
  end
end
