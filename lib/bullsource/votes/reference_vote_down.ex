defmodule Bullsource.Votes.ReferenceVoteDown do
  use Ecto.Schema

  alias Bullsource.Discussion.Reference
  alias Bullsource.Accounts.User

  schema "reference_votes_down" do
    belongs_to :reference, Reference
    belongs_to :user, User

    timestamps()

  end
end