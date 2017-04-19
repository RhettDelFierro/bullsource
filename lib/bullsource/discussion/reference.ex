defmodule Bullsource.Discussion.Reference do
  use Ecto.Schema

  schema "references" do
    field :link, :string
    field :title, :string

  end
end
