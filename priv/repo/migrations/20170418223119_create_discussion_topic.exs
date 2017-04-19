defmodule Bullsource.Repo.Migrations.CreateBullsource.Discussion.Topic do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :name, :string
      add :description, :string

      timestamps()
    end

   create unique_index(:topics, [:name])
   create unique_index(:topics, [:email])

  end
end
