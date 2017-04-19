defmodule Bullsource.Discussion.Reference do
  use Ecto.Schema

  alias Bullsource.Discussion.Proof

  schema "references" do
    field :link, :string
    field :title, :string

    belongs_to :proof, Proof

  end
end
