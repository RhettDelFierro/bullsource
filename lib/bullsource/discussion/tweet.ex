defmodule Bullsource.Discussion.Tweet do
  use Ecto.Schema

  alias Bullsource.Discussion.{Topic, Post, Tweet}

  schema "headlines" do
    field :tweet_id, :string
    field :twitter_user, :string
  end

end
