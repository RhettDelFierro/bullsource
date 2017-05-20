defmodule Bullsource.GraphQL.Schema do
#defines the shape of our api. We can practically do away with the router.
#this schema is a plug
  use Absinthe.Schema
#  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
#  alias Bullsource.Accounts.User
#  alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
#                                ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}
  import_types Bullsource.GraphQL.Types

  query do
    @desc "Lists all the topics"
    field :topic, list_of(:topic) do
      resolve &Bullsource.GraphQL.TopicResolver.list/2
    end
  end

  mutation do
    @desc "Create a topic"
    field :create_topic, :topic do
        arg :name, non_null(:string)
        arg :description, :string
        #the args above will be passed in to the resolve/2 function as a map.
        resolve &Bullsource.GraphQL.TopicResolver.create/2
    end

    @desc "Create a thread"
    field :create_thread, :thread do
      arg :title, non_null(:string)
      arg :topic_id, non_null(:integer)
      resolve &Bullsource.GraqphQL.ThreadResolver.create/2
    end
  end
end