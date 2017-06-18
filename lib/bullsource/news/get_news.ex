defmodule Bullsource.News.GetNews do
  use GenServer

  @default_news_url "https://newsapi.org/v1/articles?"

  defmodule News do
    defstruct author: nil,
              title: nil,
              description: nil,
              url: nil,
              urlToImage: nil,
              publishedAt: nil
  end

  ###
  # Public API
  ###


  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_news(_args)do
    GenServer.call(__MODULE__, :get_news)
  end



  ###
  # GenServer API
  ###

  def init(_state) do
    state = update_news()
    set_schedule()
    {:ok, state} # state :: [%articles: [%News{}],sortBy: string, source: string, status: ok}]
  end

  def handle_call(:get_news, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch_headlines_hourly, state) do
    state = update_news()
    set_schedule() # Reschedule once more
    {:noreply, state}
  end

  def handle_info(:error_parse_json, state) do
    {:stop, :json_parse_error, :error, state}
  end

  def terminate(reason, state) do
    {:stop, :error, state}
  end


  ###
  # Private functions
  ###

  defp update_news do
    networks = Bullsource.News.GetNetworks.get_networks([])
    state = networks
      |> get_headlines([])
      |> Enum.map(&format_list(&1))
  end

  defp set_schedule() do
    #check every hour for news updates/top stories
    Process.send_after(self(), :fetch_headlines_hourly, 1 * 60 * 60 * 1000 )
  end

  defp api_key do
    Application.get_env(:bullsource, :news_api)[:api_key]
  end

  defp build_url(url, network) do
#  not all sortBys's are available for each network.
    query = "#{url}&apiKey=#{api_key()}&source=#{network.id}&sortBy=#{List.first(network.sortBysAvailable)}"
    query
  end

  defp get_headlines([], acc), do: acc
  defp get_headlines([n | ns], acc) do
    headline = build_url(@default_news_url,n)
    task = Task.async(fn -> HTTPoison.get(headline) end)
#    response = Task.await(task)

    get_headlines(ns, [{n, task} | acc])
  end

  defp format_list({network,task}) do
    %{articles: articles, sortBy: sortBy} = parse_json(Task.await(task))

    %{ network: network, news: articles, sortBy: sortBy }
  end

  defp parse_json({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    %{"articles" => articles, "sortBy" => sortBy} = body |> Poison.decode!(as: %{"articles" => [%News{}]})

    articles = Enum.map(articles, &Map.put(&1, :url_to_image, &1.urlToImage))
     |> Enum.map(&Map.put(&1, :published_at, &1.publishedAt))
     |> Enum.map(&Map.drop(&1, [:urlToImage, :publishedAt]))

     %{articles: articles, sortBy: sortBy}
  end

  defp parse_json(error) do
#    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_parse_json, [])
  end

end