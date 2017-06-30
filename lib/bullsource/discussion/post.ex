defmodule Bullsource.Discussion.Post do
  use Ecto.Schema

  alias Bullsource.Accounts.User
  alias Bullsource.Discussion.Headline
  alias Bullsource.Discussion.Reference
  alias Bullsource.Votes.{PostVoteUp, PostVoteDown}

  schema "posts" do
    field :intro, :string

    belongs_to :headline, Headline
    belongs_to :user, User

    many_to_many :posts, Reference, join_through: "posts_references"
    has_many :post_vote_down, PostVoteDown
    has_many :post_vote_up, PostVoteUp

    timestamps()
  end
end
