defmodule Bullsource.SocialMedia.Twitter.TrendingTweets do
  use GenServer

  @oauth2_application_twitter_url "https://api.twitter.com/oauth2/token"
  @twitter_search_filter_url "https://api.twitter.com/1.1/search/tweets.json?q="
  @twitter_trends_url "https://api.twitter.com/1.1/trends/place.json?id="


  defmodule Bearer, do: defstruct token_type: nil, access_token: nil
  defmodule TokenError, do: defstruct code: nil, label: nil, message: nil

  defmodule TwitterTrend, do: defstruct name: nil, url: nil, promoted_content: nil, query: nil, tweet_wolume: nil

  defmodule Tweet do
    defstruct created_at: nil,
              id_str: nil,
              text: nil,
              truncated: false,
              entitities: nil,
              extended_entitites: [],
              metadata: nil,
              source: nil,
              in_reply_to_status_id: nil,
              in_reply_to_status_id_str: nil,
              in_reply_to_user_id: nil,
              in_reply_to_user_id_str: nil,
              in_reply_to_screen_name: nil,
              user: %{},
              geo: nil,
              coordinates: nil,
              place: nil,
              contributors: nil,
              retweeted_status: %{},
              is_quote_status: false,
              retweet_count: 0,
              favorite_count: 0,
              favorited: false,
              retweeted: false,
              possibly_sensitive: false,
              lang: nil
  end


  ###
  # Public API
  ###

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_tweets(_args) do
    GenServer.call(__MODULE__, :get_tweets)
  end

  def get_only_tweets(_args) do
    GenServer.call(__MODULE__, :get_only_tweets)
  end

  ###
  # GenServer API
  ###
  def init(_state) do
# global woeid = 1
# united states = 23424977
    token = encode_secret() |> get_bearer_token() |> parse_json_validate()
    stories = update_tweets(token,23424977)
    set_schedule()
    {:ok, %{token: token, stories: stories}}
  end

  def handle_call(:get_tweets, _from, state) do
    {:reply, state.stories, state}
  end

  def handle_call(:get_only_tweets, _from, state) do
    {:reply, Enum.take(state.stories.tweets,2), state}
  end


  def handle_info(:fetch, state) do
    stories = update_tweets(state.token,23424977)
    set_schedule() # Reschedule once more
    {:noreply, %{token: state.token, stories: stories}}
  end

  def handle_info(:error_parse_json, state) do

    {:stop, :json_parse_error, :error, state}
  end

  def handle_info({:error_json_validate, errors}, state) do
    {:stop, :json_parse_error_validate, :error, state}
  end

  def handle_info({:error_json_trends}, state) do
    {:stop, :json_parse_error_trends, :error, state}
  end

  def handle_info({:error_json_final}, state) do
    {:stop, :json_parse_error_trends, :error, state}
  end

  def terminate(reason, state) do
    {:stop, :error, state}
  end





  ###
  # Private functions
  ###

# keep in mind, when you have to update, you'll be querying for a new token, find some way to get the token from state?
  defp update_tweets(token, woe_id) do
    news = Bullsource.News.GetNews.get_news([]) |> Enum.filter(&(&1.network.language == "en" && &1.network.country == "us"))
    stories = news
      |> make_tweet_requests([], token)
      |> Enum.map(&format_list(&1, [])) # => [%{network, headline, tweets}]
      |> List.flatten
    stories
  end

  defp build_trend_url(woe_id) do
    @twitter_trends_url <> "#{woe_id}"
  end

  defp make_tweet_requests([], acc, _token) do
    acc
  end

  defp make_tweet_requests([n | ns], acc, token) do
    %{network: network, news: headlines} = n
    headlines = Enum.take(headlines,3) #take only the top 3 headlines from each news source.
    tasks =
      Enum.map(headlines,&build_search_url_query(&1)) #have search queries
      |> Enum.map(fn {headline, query_url} ->
          {headline,
            Task.async(fn -> HTTPoison.get(query_url,
                         ["Authorization": "Bearer #{token.access_token}"])
                       end)}
            end)
    make_tweet_requests(ns, [{network, tasks} | acc], token)
  end

  def build_search_url_query(headline) do
    encoded_query = URI.encode(headline.url)
    filters = "%20filter:news%20exclude:retweets%20exclude:replies&tweet_mode=extended&result_type=popular"

    query_url = @twitter_search_filter_url <> "%22#{encoded_query}%22#{filters}"
    {headline, query_url}
  end



  defp set_schedule() do
     Process.send_after(self(), :fetch, 1 * 60 * 30 * 1000) #check every 30 minutes (rate limit is 450 requests/15 minutes)
  end

  defp api_key do
    Application.get_env(:bullsource, :twitter)[:consumer_api_key]
  end

  defp secret_api_key do
    Application.get_env(:bullsource, :twitter)[:consumer_secret_api_key]
  end

  defp encode_secret do
    Base.encode64("#{api_key()}:#{secret_api_key()}")
  end


  defp format_list({network, []}, acc), do: acc

  defp format_list({network, [t | ts] }, acc) do
     {headline, task} = t
#     IO.puts "++++++#{inspect task}"
     tweets = parse_json_final(Task.await(task))
     |> Enum.sort(&(&1.retweet_count >= &2.retweet_count))
#     IO.puts "+_+_+_+_+_+_+_+_+_+_+#{inspect tweets}"
     news = %{network: network, news: headline, tweets: tweets}
     format_list({network, ts}, [news | acc])
  end


  defp get_bearer_token(secret) do
    headers = ["Authorization": "Basic #{secret}", "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8."]
    HTTPoison.post(@oauth2_application_twitter_url, "grant_type=client_credentials", headers)
  end

  defp parse_json_validate({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
#    IO.puts "====================1 #{inspect body}"
    body |> Poison.decode!(as: %Bearer{})
#    body |> Poison.decode!(as: %{sources: [%Network{}]})
  end

  defp parse_json_validate({:ok, %HTTPoison.Response{body: body, status_code: 401}}) do
#    IO.puts "====================2 #{inspect body}"
    errors = body |> Poison.decode!(as: %{"errors" => [%TokenError{}]})
    errors = body |> Poison.decode!(as: %{"errors" => [%TokenError{}]})
    Process.send(self(), {:error_json_validate, errors["errors"][0].message}, [])
  end

  defp parse_json_validate({:ok, %HTTPoison.Response{body: body, status_code: 403}}) do
#    IO.puts "==================3 #{inspect body}"
    errors = body |> Poison.decode!(as: %{"errors" => [%TokenError{}]})
    Process.send(self(), {:error_json_validate, errors["errors"][0].message}, [])
  end

  defp parse_json_validate(error) do
#    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_json_validate, [])
  end



  defp parse_json_final({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    %{"statuses" => tweets} = body |> Poison.decode!(as: %{"statuses" => [%Tweet{}]})

    tweets = Enum.map(tweets,
        &Map.put(&1,:retweeted_status, Bullsource.Helpers.Converters.str_to_atom_keys(&1.retweeted_status)))
      |> Enum.map(&Map.put(&1,:user, Bullsource.Helpers.Converters.str_to_atom_keys(&1.user)))
#      |> Enum.map(&Map.put(&1.retweeted_status,:, Bullsource.Helpers.Converters.str_to_atom_keys(&1.user)))

  end

  defp parse_json_final(error) do
    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_json_final, [])
  end

end