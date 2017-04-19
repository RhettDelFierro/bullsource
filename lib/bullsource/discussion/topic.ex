defmodule Bullsource.Discussion.Topic do
  use Ecto.Schema

  alias Bullsource.Discussion.Thread

  schema "topics" do

    field :name, :string, unique: true
    field :description, :string

    has_many :threads, Thread

    timestamps()

  end
end
