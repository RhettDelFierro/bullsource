defmodule Bullsource.Repo.Migrations.CreateBullsource.Discussion.Reference do
  use Ecto.Migration

  def change do
    create table(:references) do
      add :link, :string
      add :title, :string

      add :proof_id, references(:proofs)
    end

  end
end
