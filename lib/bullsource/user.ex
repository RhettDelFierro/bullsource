defmodule Bullsource.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :username, :string

    timestamps()
  end
end
