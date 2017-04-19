defmodule Bullsource.Discussion.Article do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof

  schema "articles" do
    field :text, :string

    belongs_to :proof, Proof

  end
end
