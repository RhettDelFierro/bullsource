defmodule Bullsource.Discussion.Comment do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof

  schema "comments" do
    field :text, :string

    belongs_to :proof, Proof

    timestamps()
  end
end
