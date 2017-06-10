defmodule Bullsource.GraphQL.NewsTweetsResolver do
  import Bullsource.News.GetNews, only: [get_news: 1]
  import Bullsource.SocialMedia.Twitter.TrendingTweets, only: [get_tweets: 1]

  alias Bullsource.SocialMedia.Twitter.TrendingTweets.Tweet
  alias Bullsource.News.GetNews.News
  alias Bullsource.News.GetNetworks.Network

  def list(_args, _context) do
    news = get_news([])
#    IO.inspect news
    feed = get_tweets([])
    IO.inspect feed
#    matched_stories = Enum.map(news, fn m ->
#       #iterate through m.news and see if any of those urls match the expanded_url
#       #if they do, return both the story and the tweet(s)
#       matching_stories = for headline <- m.news do
#                            filtered_tweets =
#                              Enum.filter(tweets, fn t ->
#                                if (t.retweeted_status["full_text"] != nil) do
#                                  if(t.retweeted_status["full_text"] =~ headline.url) do
#                                   IO.puts "true"
#                                  end
#                                  t.retweeted_status["full_text"] =~ headline.url
#                                else
#                                 :false
#                                end
#
#
##                                if (t.retweeted_status["entities"]["urls"] != []  && t.retweeted_status["entities"]["urls"] != nil) do
###                                  [head | _tail] = t.retweeted_status["entities"]["urls"]
##                                  [head | _tail] = Enum.take(t.retweeted_status["entities"]["urls"],1)
##
##                                  IO.puts "#{if (head["expanded_url"] == headline.url), do: IO.puts "true"}"
###                                  IO.inspect headline.url
###                                  Enum.take(t.retweeted_status["entities"]["urls"],1)[:expanded_url] == headline.url
##                                else
##                                  :false
##                                end
##                              end)
#                              end)
##                              |> Enum.map(&(IO.puts "========#{Enum.take(&1.retweeted_status["entities"]["urls"],1)[:expanded_url]}"))
##                              |> Enum.map(&(Map.new(
##                                            [id: &1.id,
##                                             full_text: &1.retweeted_status["full_text"],
##                                             retweet_count: &1.retweet_count,
##                                             expanded_url: Enum.take(&1.retweeted_status["entities"]["urls"],1)[:expanded_url],
##                                             user_id: &1.user["id"]
##                                            ]
##                                     )
##                                 ))
#
#                            %{
#                              network: m.network,
#                              news: headline,
#                              tweets: filtered_tweets
#                            }
#                          end
#    end)
#    IO.inspect tweets
#    [[feed]] = stories
#    IO.inspect stories
    {:ok, %{news_tweet: feed}}
  end
end