defmodule Bullsource.Discussion do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Repo

  def list_topics do
    Repo.all(Topic)
  end

  def create_topic(params) do
    topic_changeset(params) |> Repo.insert
  end

  def topic_changeset(params \\ %{}) do
    %Topic{}
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]*$/)
    |> validate_length(:name, max: 32)
    |> validate_length(:name, min: 1)
    |> validate_length(:description, max: 140)
    |> validate_length(:description, min: 1)
    |> unique_constraint(:name)
  end

  def list_threads_in_topic(topic_id) do
    Repo.get(Topic,topic_id) |> preload(:threads) |> preload(:users)
  end

  def create_thread(params) do
    thread_changeset(params) |> Repo.insert
  end

  def thread_changeset(params \\ %{}) do
    %Thread{}
    |> cast(params, [:title, :user_id, :topic_id])
    |> validate_required([:title, :user_id, :topic_id])
    |> validate_length(:title, max: 300)
    |> validate_length(:title, min: 3)
    |> unique_constraint([:name, :user_id, :topic_id])
    |> assoc_constraint(:topic)
  end

end