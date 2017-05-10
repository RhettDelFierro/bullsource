defmodule Bullsource.Votes.PostVoteDown do
  use Ecto.Schema

  alias Bullsource.Discussion.Post
  alias Bullsource.Accounts.User

  schema "post_votes_down" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps()

  end

end