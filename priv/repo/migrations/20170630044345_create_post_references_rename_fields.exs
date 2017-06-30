defmodule Bullsource.Repo.Migrations.CreatePostReferencesRenameFields do
  use Ecto.Migration

  def change do

    create table(:posts_references, primary_key: false) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :reference_id, references(:references, on_delete: :delete_all)
    end

    alter table(:references) do
      add :doi, :string, unique: true
      remove :link
      remove :title
    end

    alter table(:posts) do
      remove :intro
      add :body, :text
    end

    drop table(:articles)
    drop table(:comments)
    drop table(:proof_votes_up)
    drop table(:proof_votes_down)

  end
end
