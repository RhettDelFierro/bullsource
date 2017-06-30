defmodule Bullsource.GraphQL.Types.VoteTypes do
  use Absinthe.Ecto, repo: Bullsource.Repo
  use Absinthe.Schema.Notation

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


end