defmodule Bullsource.Discussion.Post do
  use Ecto.Schema

  schema "posts" do
    field :intro, :string



    timestamps()
  end
end
