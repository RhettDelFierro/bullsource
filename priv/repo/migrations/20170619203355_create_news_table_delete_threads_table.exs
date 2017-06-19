defmodule Bullsource.Repo.Migrations.CreateNewsTableDeleteThreadsTable do
  use Ecto.Migration

  def change do

    create table(:tweets) do
      add :tweet_id, :string # this is the original id of the original story tweet. #crawl the url page for this? using meta tags?
      add :twitter_user, :string
    end

    create table(:headlines) do
      add :title, :string
      add :network, :string
      add :url, :string
      add :description, :text
      add :published_at, :text
      add :url_to_image, :string
      add :topic_id, references(:topics)

      timestamps()
    end

    create unique_index(:headlines, [:title, :network], name: :title_network_index)

    alter table(:posts) do
      add :headline_id, references(:headlines)
      remove :thread_id
    end

    drop table(:threads)

  end
end
