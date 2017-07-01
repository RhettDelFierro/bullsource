defmodule Bullsource.Discussion.Body do
  use Ecto.Schema

  embedded_schema do
    field :blocks, :map
    field :entity_map, :map
  end
end