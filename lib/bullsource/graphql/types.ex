defmodule Bullsource.GraphQL.Types do
  use Absinthe.Schema.Notation


  @desc "User - has many Posts, Threads and all Votes."
  object :user do
    field :id, :integer
    field :username, :string
    field :email, :string

#    field :threads, list_of(:thread) do
#     resolve &Bullsource.GraphQL.ThreadResolver.assoc/2
#    end
#
#    field :posts, list_of(:post) do
#     resolve &Bullsource.GraphQL.PostResolver.assoc/2
#    end

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

  @desc "A JWT Token"
  object :token do
    field :token, :string
  end

end