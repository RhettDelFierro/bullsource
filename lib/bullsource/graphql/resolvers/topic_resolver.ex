defmodule Bullsource.GraphQL.TopicResolver do
    alias Bullsource.{Repo,Discussion.Topic}

    def list(_args, _context) do
      {:ok, Repo.all(Topic)}
    end

    def create(%{name: name, description: description}, _context) do
      {:ok, Repo.insert!(%Topic{name: name, description: description})}
    end
end