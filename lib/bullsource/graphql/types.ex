defmodule Bullsource.GraphQL.Types do
  use Absinthe.Ecto, repo: Bullsource.Repo
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
    field :threads, list_of(:thread), resolve: assoc(:threads)
  end

  @desc "Threads belong to topics and users. Has many posts."
  object :thread do
    field :id, :integer
    field :title, :string
    field :user, :user, resolve: assoc(:user)
    field :posts, list_of(:post), resolve: assoc(:posts)
  end

  @desc "Posts belong to Threads and Users. Has many Proofs and References"
  object :post do
    field :id, :integer
    field :intro, :string
    field :thread_id, :integer
    field :user_id, :integer
    field :proofs, list_of(:proof), resolve: assoc(:proofs)

#    field :votes, list_of(:vote) do
#    #wrapper functions for this so we could use one .assoc/2 function in VoteResolver?
#      resolve &Bullsource.GraphQL.VoteResolver.assoc/2
#    end
  end

  @desc "Proofs - belong to Posts and References. has_one Article and Comment."
  object :proof do
    field :id, :integer
    field :reference_id, :integer
    field :post_id, :integer
    field :article, :article, resolve: assoc(:article)
    field :comment, :comment, resolve: assoc(:comment)

#    field :reference, :reference do
#      resolve &Bullsource.GraphQL.ReferenceResolver.assoc/2
#    end

  end

  @desc "Articles - belong to proofs - quoted from Reference :link"
  object :article do
    field :id, :integer
    field :text, :string
    field :proof_id, :integer
  end

  @desc "Comments - belong to proofs - personal comments on article/reference"
  object :comment do
    field :id, :integer
    field :text, :string
    field :proof_id, :integer
  end

  @desc "References - has many proofs"
  object :reference do
    field :id, :integer
    field :link, :string
    field :title, :string
    field :proofs, list_of(:proof), resolve: assoc(:proofs)
  end

  @desc "Vote - "
  object :vote do
    field :id, :integer #the id of whatever the vote was in :vote_type table.
    field :vote_type_id, :integer #the foreign key id of the item voted on.
    field :vote_type, :vote_type
#    field :user, :user do
#      resolve &Bullsource.GraphQL.UserResolver.vote_assoc/2
#    end
  end

  @desc "Vote type"
  enum :vote_type do
    value :up_vote_post
    value :down_vote_post
    value :up_vote_proof
    value :down_vote_proof
    value :up_vote_reference
    value :down_vote_reference
  end

  @desc "A JWT Token"
  object :token do
    field :token, :string
  end

######## input_objects
  @desc "An input object for :post"
  input_object :input_post do
    field :intro, :string
    field :proofs, list_of(non_null(:input_proof))
  end

  @desc "An input object for :proof"
  input_object :input_proof do
    field :article, :string
    field :comment, :string
    field :reference, non_null(:input_reference)
  end

  @desc "An input object for :article"
  input_object :input_article do
    field :text, :string
  end

  @desc "An input object for :comment"
  input_object :input_comment do
    field :text, :string
  end

  @desc "An input object for :reference"
  input_object :input_reference do
    field :link, non_null(:string)
    field :title, :string
  end

end