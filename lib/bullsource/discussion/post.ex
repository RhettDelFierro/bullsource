defmodule Bullsource.Discussion.Post do
  use Ecto.Schema

  alias Bullsource.Accounts.User
  alias Bullsource.Discussion.Headline
  alias Bullsource.Discussion.Proof
  alias Bullsource.Votes.{PostVoteUp, PostVoteDown}

  schema "posts" do
    field :intro, :string

    belongs_to :headline, Headline
    belongs_to :user, User

    has_many :proofs, Proof
    has_many :post_vote_down, PostVoteDown
    has_many :post_vote_up, PostVoteUp

    timestamps()
  end
end
