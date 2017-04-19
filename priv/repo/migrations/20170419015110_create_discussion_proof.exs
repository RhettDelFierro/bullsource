defmodule Bullsource.Repo.Migrations.CreateBullsource.Discussion.Proof do
  use Ecto.Migration

  def change do
    create table(:proofs) do
      add :post_id, references(:posts)

    end

  end
end
