defmodule Bullsource.Discussion.Thread do
  use Ecto.Schema

  schema "threads" do
    field :title, :string

    timestamps()
  end
end
