defmodule Bullsource.GraphQL.Schema do
#defines the shape of our api. We can practically do away with the router.
#this schema is a plug
  use Absinthe.Schema
#  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
#  alias Bullsource.Accounts.User
#  alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
#                                ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}
  alias Bullsource.Repo
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
  alias Bullsource.Accounts.User
  alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                                ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}
  @desc "Topics has many threads."
  object :topic do
    field :id, :integer
    field :name, :string
    field :description, :string

    #because :topic has_many :threads, we're going to add a :threads field
    field :threads, list_of(:thread) do
      resolve(_args, %{source: topic}) -> #we can define how every field is resolved with the resolve/2 function.
        topic = Repo.preload(topic, :threads)
        {:ok, topic.threads}
    end
  end

  @desc "Threads belong to toics and users. Has many posts."
  object :thread do
    field :id, :integer
    field :title, :string

    timestamps()
  end

  query do
    @desc "Lists all the topics"
    field :topic, list_of(:topic) do
      resolve fn(_args, _context) ->
        {:ok, Repo.all(Topic)}
      end
    end
  end

  mutation do
    @desc "Create a topic"
    field :create_topic, :topic do
        arg :name, non_null(:string)
        arg :description, :string
        #the args above will be passed in to the resolve/2 function as a map.
        resolve fn(%{name: name, description: description}, _context) ->
            topic = Repo.insert! %Topic{name: name, description: description}
            {:ok, topic}
        end
    end
  end
end