defmodule Bullsource.Discussion.Post do
  use Ecto.Schema

  alias Bullsource.Accounts.User
  alias Bullsource.Discussion.Thread
  alias Bullsource.Discussion.Proof


  schema "posts" do
    field :intro, :string

    belongs_to :thread, Thread
    belongs_to :user, User

    has_many :proofs, Proof

    timestamps()
  end
end
