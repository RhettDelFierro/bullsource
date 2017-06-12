defmodule Bullsource.GraphQL.Types.NewsTweetTypes do
  use Absinthe.Ecto, repo: Bullsource.Repo
  use Absinthe.Schema.Notation

  @desc "News - network and headlines."
  object :news do
    field :author, :string
    field :title, :string
    field :description, :string
    field :country, :string
    field :url, :string
    field :urlToImage, :string
    field :publishedAt, :string
  end

  @desc "Network"
  object :network do
    field :id, :string
    field :name, :string
    field :description, :string
    field :url, :string
    field :category, :string
    field :language, :string
    field :country, :string
  end

  @desc "Tweet Object."
  object :tweet do
    field :id, :integer
    field :retweet_count, :integer
    field :retweeted_status, :retweeted_status
    field :user, :twitter_user
  end

  @desc "Retweeted_status of tweets - it's main data.'"
  object :retweeted_status do
    field :full_text, :string
  end

  @desc "User of Tweet"
  object :twitter_user do
    field :profile_background_image, :string
    field :name, :string
  end

  @desc "tweets and matching News"
  object :news_tweet do
    field :network, :network
    field :news, :news
    field :tweets, list_of(:tweet)
  end
end