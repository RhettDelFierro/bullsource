defmodule Bullsource.Repo.Migrations.AddReferenceIdToProofs do
  use Ecto.Migration

  def change do
    drop table(:proof_references)
    alter table(:proofs) do
      add :reference_id, references(:references)
    end
  end
end
