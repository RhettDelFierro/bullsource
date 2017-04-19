defmodule Bullsource.Repo.Migrations.CreateBullsource.Discussion.Article do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :text, :string

      add :proof_id, references(:proofs)

    end

  end
end
