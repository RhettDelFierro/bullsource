defmodule Bullsource.Discussion.Proof do
  use Ecto.Schema

  alias Bullsource.Discussion.Post
  alias Bullsource.Discussion.Article
  alias Bullsource.Discussion.Comment
  alias Bullsource.Discussion.Reference
  alias Bullsource.Votes.{ProofVoteUp, ProofVoteDown}

  schema "proofs" do
    belongs_to :post, Post
    belongs_to :reference, Reference

    has_one :article, Article
    has_one :comment, Comment
    has_many :proof_votes_down, ProofVoteDown
    has_many :proof_votes_up, ProofVoteUp

  end

end
