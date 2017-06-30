defmodule Bullsource.Repo.Migrations.DropProofs do
  use Ecto.Migration

  def change do
    drop table(:proofs)
  end
end
