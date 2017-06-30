defmodule Bullsource.Repo.Migrations.PostsBodyToMap do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :body
      add :body, :map
    end
  end
end
