defmodule Bullsource.Discussion.Headline do
  use Ecto.Schema

  alias Bullsource.Discussion.{Topic, Post, Tweet}

  schema "headlines" do
    field :title, :string
    field :network, :string
    field :url, :string
    field :description, :string
    field :published_at, :string
    belongs_to :topic, Topic

    has_many :posts, Post
    has_many :tweets, Tweet

    timestamps()
  end

end
