defmodule Bullsource.Repo.Migrations.CreateBullsource.Discussion.Post do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :intro, :string

      add :user_id, references(:users)
      add :thread_id, references(:threads)

      timestamps()
    end

  end
end
