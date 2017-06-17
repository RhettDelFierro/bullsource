defmodule Bullsource.GraphQL.NewsTweetsResolver do
  import Bullsource.News.GetNews, only: [get_news: 1]
  import Bullsource.SocialMedia.Twitter.TrendingTweets, only: [get_tweets: 1]

  alias Bullsource.SocialMedia.Twitter.TrendingTweets.Tweet
  alias Bullsource.News.GetNews.News
  alias Bullsource.News.GetNetworks.Network

  def list(_args, _context) do
#    IO.inspect news
    feed = get_tweets([])
#    Enum.each(feed,&(IO.inspect &1.tweets))
    {:ok, feed}
  end

  def filter(%{category: category, network: network}, _context) do
    feed = get_tweets([])
      |> Enum.filter(&(&1.news.category == category || &1.network.name == network))

    {:ok, feed}
  end
end