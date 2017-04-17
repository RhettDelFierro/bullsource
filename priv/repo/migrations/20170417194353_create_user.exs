defmodule Bullsource.Repo.Migrations.CreateBullsource.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :encrypted_password, :string

      timestamps()
    end

  end
end
