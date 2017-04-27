defmodule Bullsource.Repo.Migrations.DropProofIdInReferences do
  use Ecto.Migration

  def change do
    alter table(:references) do
      remove :proof_id
    end
  end
end
