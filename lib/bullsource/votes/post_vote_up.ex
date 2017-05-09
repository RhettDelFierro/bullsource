defmodule BullSource.Votes.PostVoteUp do
  alias Bullsource.Discussion.Post
  alias Bullsource.Accounts.User

  schema "post_votes_up" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps()

  end
end