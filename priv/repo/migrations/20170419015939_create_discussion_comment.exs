defmodule Bullsource.Repo.Migrations.CreateBullsource.Discussion.Comment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :string

      add :proof_id, references(:proofs)

      timestamps()
    end

  end
end
