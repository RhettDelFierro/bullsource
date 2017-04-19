defmodule Bullsource.Discussion.Comment do
  use Ecto.Schema

  schema "comments" do
    field :text, :string

    timestamps()
  end
end
