defmodule Bullsource.User do
  use Ecto.Schema

  schema "users" do

    field :username, :string, unique: true
    field :email, :string, unique: true
    field :encrypted_password, :string


    timestamps()
  end
end
