defmodule Bullsource.Repo.Migrations.RemoveUniqueIndexThreads do
  use Ecto.Migration

  def change do
    execute "DROP TABLE if exists threads cascade"

    create table(:threads) do
      add :title, :string
      add :user_id, references(:users)
      add :topic_id, references(:topics)

      timestamps()
    end

  end
end
