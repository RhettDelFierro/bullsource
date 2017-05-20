defmodule Bullsource.GraphQL.TopicResolver do
    alias Bullsource.Repo
    alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
    alias Bullsource.Accounts.User
    alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                                    ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}

    def list(_args, _context) do
      {:ok, Repo.all(Topic)}
    end

    def create(%{name: name, description: description}, _context) do
      {:ok, Repo.insert!(%Topic{name: name, description: description})}
    end
end