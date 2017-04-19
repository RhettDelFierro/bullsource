defmodule Bullsource.Discussion.Topic do
  use Ecto.Schema

  schema "topics" do

    field :name, :string, unique: true
    field :description, :string

    timestamps()

  end
end
