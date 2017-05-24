defmodule Bullsource.GraphQL.Types do
  use Absinthe.Ecto, repo: Bullsource.Repo
  use Absinthe.Schema.Notation


  @desc "User - has many Posts, Threads and all Votes."
  object :user do
    field :id, :integer
    field :username, :string
    field :email, :string

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
    field :up_votes, list_of(:post_vote_up), resolve: assoc(:post_vote_up)
    field :down_votes, list_of(:post_vote_down), resolve: assoc(:post_vote_down)
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

  @desc "PostVoteUp"
  object :post_vote_up do
    field :id, :integer
    field :post, :post, resolve: assoc(:post)
    field :user, :user, resolve: assoc(:user)
  end

  @desc "PostVoteDown"
  object :post_vote_down do
    field :id, :integer
    field :post, :post, resolve: assoc(:post)
    field :user, :user, resolve: assoc(:user)
  end

  @desc "ProofVoteUp"
  object :proof_vote_up do
    field :id, :integer
    field :proof, :proof, resolve: assoc(:proof)
    field :user, :user, resolve: assoc(:user)
  end

  @desc "ProofVoteDown"
  object :proof_vote_down do
    field :id, :integer
    field :prook, :post, resolve: assoc(:proof)
    field :user, :user, resolve: assoc(:user)
  end

  @desc "ReferenceVoteUp"
  object :reference_vote_up do
    field :id, :integer
    field :reference, :reference, resolve: assoc(:reference)
    field :user, :user, resolve: assoc(:user)
  end

  @desc "ReferenceVoteDown"
  object :reference_vote_up do
    field :id, :integer
    field :reference, :reference, resolve: assoc(:reference)
    field :user, :user, resolve: assoc(:user)
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

  @desc "Vote object"
  object :vote do
    field :id, :integer #the id of whatever the vote was in :vote_type table.
    field :user, :user, resolve: assoc(:user)
    field :vote_type, :vote_type
    field :vote_type_id, :integer #will be reference_id, post_id, proof_id
    # to list the right association, read the :vote_type off the args in the assoc/2 function.
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