defmodule Bullsource.GraphQL.NewsTweetsResolver do
  import Bullsource.News.GetNews, only: [get_news: 1]
  import Bullsource.SocialMedia.Twitter.TrendingTweets, only: [get_tweets: 1]

  def list(_args, _context) do
    news = get_news([])
#    IO.inspect news
#    tweets = get_tweets([])

      #maybe a list comprehension.
  end
end