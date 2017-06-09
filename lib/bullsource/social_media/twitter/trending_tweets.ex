defmodule Bullsource.SocialMedia.Twitter.TrendingTweets do
  use GenServer

  @default_twitter_url "https://api.twitter.com"
  @twitter_search_url "https://twitter.com/search?q="
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

  def get_networks(_args)do
    GenServer.call(__MODULE__, :get_networks)
  end



  ###
  # GenServer API
  ###
  def init(_state) do
    #get sources from the other GetNetworks
    token = encode_secet() |> get_bearer_token
    state = %{token: token}

    |> HTTPoison.get([], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    |> parse_json

    set_schedule()
    {:ok, state}
  end

  defp query_twitter(token) do
    search =
  end

  def handle_call(:get_tweets, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch, state) do
    set_schedule() # Reschedule once more
    {:noreply, state}
  end

  def handle_info(:error_parse_json, state) do
    {:stop, :json_parse_error, :error, state}
  end

  def handle_info({:error_json_validate, errors}, state) do
    # restart?
  end

  def terminate(reason, state) do
    {:stop, :error, state}
  end



  ###
  # Private functions
  ###

  defp set_schedule() do
     Process.send_after(self(), :fetch, 1 * 60 * 30 *1000) #check every 30 minutes (rate limit is 450 requests/15 minutes)
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
    headers = ["Authorization": secret, "Context-Type": "application/x-www-form-urlencoded;charset=UTF-8."]
    HTTPoison.post(@default_twitter_url, %{grant_type: "client_credentials"}, headers)
  end




  @doc """
  category (optional) - The category you would like to get sources for.
    Possible options: business, entertainment, gaming, general, music, politics, science-and-nature, sport, technology.
    Default: empty (all sources returned)
  language	(optional) - The 2-letter ISO-639-1 code of the language you would like to get sources for.
    Possible options: en, de, fr.
    Default: empty (all sources returned)
  country	(optional) - The 2-letter ISO 3166-1 code of the country you would like to get sources for.
    Possible options: au, de, gb, in, it, us.
    Default: empty (all sources returned)
  """

  defp build_url(url) do
    url
  end

  defp parse_json_validate({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Poison.decode!(as: %Bearer{})
#    body |> Poison.decode!(as: %{sources: [%Network{}]})
  end

  defp parse_json_validate({:ok, %HTTPoison.Response{body: body, status_code: 401}}) do
    errors = body |> Poison.decode!(as: %{"errors" => [%TokenError{}]})
    Process.send(self(), {:error_json_validate, errors["errors"][0].message})
  end

  defp parse_json_validate({:ok, %HTTPoison.Response{body: body, status_code: 403}}) do
    errors = body |> Poison.decode!(as: %{"errors" => [%TokenError{}]})
    Process.send(self(), {:error_json_validate, errors["errors"][0].message})
  end

  defp parse_json_validate(error) do
#    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_json_validate, [])
  end



  defp parse_json({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Poison.decode!(as: %{"sources" => [%Network{}]})
#    body |> Poison.decode!(as: %{sources: [%Network{}]})
  end

  defp parse_json(error) do
#    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_parse_json, [])
  end

end