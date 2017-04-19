defmodule Bullsource.Discussion.Thread do
  use Ecto.Schema

  alias Bullsource.Accounts.User
  alias Bullsource.Discussion.Topic
  alias Bullsource.Discussion.Post

  schema "threads" do
    field :title, :string

    belongs_to :user, User
    belongs_to :topic, Topic

    has_many :posts, Post

    timestamps()
  end

end
