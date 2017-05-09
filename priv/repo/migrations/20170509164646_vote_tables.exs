defmodule Bullsource.Repo.Migrations.VoteTables do
  use Ecto.Migration

  def change do
    create table(:post_votes_up) do

      add :post_id, references(:posts)
      add :user_id, references(:users)

      timestamps()
    end

    create table(:post_votes_down) do

      add :post_id, references(:posts)
      add :user_id, references(:users)

      timestamps()
    end

    create table(:proof_votes_up) do

      add :proof_id, references(:proofs)
      add :user_id, references(:users)

      timestamps()
    end

    create table(:proof_votes_down) do

      add :proof_id, references(:proofs)
      add :user_id, references(:users)

      timestamps()
    end

    create table(:reference_votes_up) do

      add :reference_id, references(:references)
      add :user_id, references(:users)

      timestamps()
    end

    create table(:reference_votes_down) do

      add :reference_id, references(:references)
      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:post_votes_up, [:post_id, :user_id], name: :post_votes_up_index)
    create unique_index(:post_votes_down, [:post_id, :user_id], name: :post_votes_down_index)
    create unique_index(:proof_votes_up, [:proof_id, :user_id], name: :proof_votes_up_index)
    create unique_index(:proof_votes_down, [:proof_id, :user_id], name: :proof_votes_down_index)
    create unique_index(:reference_votes_up, [:reference_id, :user_id], name: :reference_votes_up_index)
    create unique_index(:reference_votes_down, [:reference_id, :user_id], name: :reference_votes_down_index)
  end
end
