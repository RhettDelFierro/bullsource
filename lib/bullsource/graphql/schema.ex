defmodule Bullsource.GraphQL.Schema do
#defines the shape of our api. We can practically do away with the router.
#this schema is a plug
  use Absinthe.Schema
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                                ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}
  @desc "Topics has many threads."
  object :topic do
    field :name, :string, unique: true
    field :description, :string

  end

  @desc "Threads belong to toics and users. Has many posts."
  object :thread do
    field :title, :string

    belongs_to :user, User
    belongs_to :topic, Topic

    has_many :posts, Post

    timestamps()
  end

  query do
    field :topic, list_of(:topic) do
      resolve fn(_args, _context) ->
      {:ok, Repo.all(Topic)}
    end
  end
end