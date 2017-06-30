defmodule Bullsource.Discussion.Reference do
  use Ecto.Schema

  alias Bullsource.Discussion.Post
  alias Bullsource.Votes.{ReferenceVoteUp, ReferenceVoteDown}

  schema "references" do
    field :doi, :string, unique: true

    #has_many :proof, ProofReference
    many_to_many :posts, Post, join_through: "posts_references"
    has_many :reference_votes_down, ReferenceVoteDown
    has_many :reference_votes_up, ReferenceVoteUp

  end
end
