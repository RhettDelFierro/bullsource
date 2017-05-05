defmodule Bullsource.Discussion.Proof do
  use Ecto.Schema

  alias Bullsource.Discussion.Post
  alias Bullsource.Discussion.Article
  alias Bullsource.Discussion.Comment
  alias Bullsource.Discussion.Reference

  schema "proofs" do
    belongs_to :post, Post
    belongs_to :references, Reference

    has_one :article, Article
    has_one :comment, Comment

  end

end
