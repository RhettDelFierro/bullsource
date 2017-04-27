defmodule Bullsource.Repo.Migrations.DropProofsFkReferences do
  use Ecto.Migration

  def change do
    drop_if_exists index(:references, [:proof_id])
    create table(:proof_references) do

      add :proof_id, references(:proofs, on_delete: :delete_all)
      add :reference_id, references(:references, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:proof_references, [:proof_id, :reference_id])

  end
end
