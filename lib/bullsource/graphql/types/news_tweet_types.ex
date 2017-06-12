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
    field :full_text, :string
    field :user_id, :integer
  end

  @desc "tweets and matching News"
  object :news_tweet do
    field :network, :network
    field :news, :news
    field :tweets, list_of(:tweet)
  end
end