defmodule Bullsource.Repo.Migrations.UniqueReferenceLinks do
  use Ecto.Migration

  def change do
    create unique_index(:references, [:link])
  end
end
