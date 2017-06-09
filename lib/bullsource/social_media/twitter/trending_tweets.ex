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
              id: nil,
              id_str: nil,
              text: nil,
              truncated: false,
              entitities: %{},
              extended_entitites: %{},
              metadata: %{},
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

  def get_tweets(_args)do
    GenServer.call(__MODULE__, :get_tweets)
  end



  ###
  # GenServer API
  ###
  def init(_state) do
    state = update_tweets(1)
    set_schedule()
    {:ok, state}
  end

  def handle_call(:get_tweets, _from, state) do
    {:reply, state.statuses, state}
  end

  def handle_info(:fetch, state) do
    state = update_tweets(1)
    set_schedule() # Reschedule once more
    {:noreply, state}
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
  defp update_tweets(woe_id) do
    token = encode_secret() |> get_bearer_token() |> parse_json_validate()
#    [%{"trends" => trends}] = build_trend_url(woe_id) |> search_twitter_trends(token)
    [%{"trends" => trends}] = build_trend_url(woe_id) |> search_twitter_trends(token) |> parse_json_trends()
#    IO.inspect "=================#{inspect trends}"
    statuses = Enum.map(trends, &build_search_filter_url(&1))
      |> Enum.map(&Task.async(fn ->
             HTTPoison.get(&1, ["Authorization": "Bearer #{token.access_token}"])
           end))
      |> Enum.map(&Task.await/1)
      |> Enum.map(&parse_json_final/1)
      |> Enum.map()
    %{token: token, statuses: statuses}
  end

  defp build_trend_url(woe_id) do
    @twitter_trends_url <> "#{woe_id}"
  end

  defp build_search_filter_url(trend) do
    @twitter_search_filter_url <> "#{trend.query}&filter:news"
  end

  defp search_twitter_trends(trend_url, token) do
    HTTPoison.get(trend_url, ["Authorization": "Bearer #{token.access_token}"])
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




  defp parse_json_trends({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Poison.decode!(as: [%{"trends" => [%TwitterTrend{}]}])
  end

  defp parse_json_trends(error) do
    Process.send(self(),:error_json_trends, [])
  end


  defp parse_json_final({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Poison.decode!(as: %{"statuses" => [%Tweet{}]})
#    body |> Poison.decode!(as: %{sources: [%Network{}]})
  end

  defp parse_json_final(error) do
#    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_json_final, [])
  end

end