defmodule Bullsource.GraphQL.Types.NewsTweetTypes do
  use Absinthe.Ecto, repo: Bullsource.Repo
  use Absinthe.Schema.Notation

  @desc "News - network and headlines."
  object :news do
    field :network, :integer
    field :headline, :string
    field :description, :string
    field :headline_url, :string
    field :headline_image_url, :string
  end

  @desc "Tweet Object."
  object :tweet do
    field :id, :integer
    field :full_text, :string
    field :url, :string
    field :user_id, :integer
  end

  @desc "tweets and matching News"
  object :news_tweet do
    field :network, :integer
    field :headline, :string
    field :headline_url, :string
    field :headline_image_url, :string
    field :tweet_id, :integer
    field :tweet_full_text, :string
    field :tweet_url, :string
    field :tweet_user_id, :integer
  end
end