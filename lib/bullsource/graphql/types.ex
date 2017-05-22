defmodule Bullsource.GraphQL.Types do
  use Absinthe.Schema.Notation


  @desc "User - has many Posts, Threads and all Votes."
  object :user do
    field :username, :string
    field :email, :string
    field :encrypted_password

    field :threads, list_of(:thread) do
     resolve &Bullsource.GraqphQL.ThreadResolver.assoc/2
    end

    field :posts, list_of(:post) do
     resolve &Bullsource.GraqphQL.PostResolver.assoc/2
    end

#    has_many :posts, Post
#    has_many :threads, Thread
#    has_many :post_votes_down, PostVoteDown
#    has_many :post_votes_up, PostVoteUp
#    has_many :proof_votes_down, ProofVoteDown
#    has_many :proof_votes_up, ProofVoteUp
#    has_many :reference_votes_down, ReferenceVoteDown
#    has_many :reference_votes_up, ReferenceVoteUp
  end

  @desc "Topics has many threads."
  object :topic do
    field :id, :integer
    field :name, :string
    field :description, :string

    #because :topic has_many :threads, we're going to add a :threads field
    field :threads, list_of(:thread) do
     resolve &Bullsource.GraqphQL.ThreadResolver.assoc/2
    end
  end

  @desc "Threads belong to topics and users. Has many posts."
  object :thread do
    field :id, :integer
    field :title, :string
  end
end