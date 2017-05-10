defmodule Bullsource.Votes.ReferenceVoteUp do
  use Ecto.Schema

  alias Bullsource.Discussion.Reference
  alias Bullsource.Accounts.User

  schema "reference_votes_up" do
    belongs_to :reference, Reference
    belongs_to :user, User

    timestamps()

  end
end