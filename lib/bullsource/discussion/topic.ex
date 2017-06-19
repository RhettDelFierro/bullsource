defmodule Bullsource.Discussion.Topic do
  use Ecto.Schema

  alias Bullsource.Discussion.Headline

  schema "topics" do

    field :name, :string, unique: true
    field :description, :string

    has_many :headliness, Headline

    timestamps()

  end
end
