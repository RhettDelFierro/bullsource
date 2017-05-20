defmodule Bullsource.GraphQL.Types do
  use Absinthe.Schema.Notation

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