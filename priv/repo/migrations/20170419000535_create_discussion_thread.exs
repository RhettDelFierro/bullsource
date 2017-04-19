defmodule Bullsource.Repo.Migrations.CreateBullsource.Discussion.Thread do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :title, :string
      add :user_id, references(:users)
      add :topic_id, references(:topics)

      timestamps()
    end

    create unique_index(:threads, [:title, :user_id, :topic_id])

  end

end
