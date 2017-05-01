defmodule Bullsource.Discussion.Proof do
  use Ecto.Schema

  alias Bullsource.Discussion.Post
  alias Bullsource.Discussion.Article
  alias Bullsource.Discussion.Comment
  alias Bullsource.Discussion.Reference

  schema "proofs" do
    belongs_to :post, Post

    has_one :article, Article
    has_one :comment, Comment
    many_to_many :references, Reference, join_through: "proof_references"
  end

end