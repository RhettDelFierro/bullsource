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
    networks = Bullsource.News.GetNetworks.get_networks([])
    state = networks
      |> get_headlines(5)
      |> Enum.map(&parse_json(&1))
#      |> Enum.map(&Enum.take(&1,5))
    set_schedule()
    {:ok, state}
  end

  def handle_call(:get_news, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch_headlines_hourly, state) do
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

  defp set_schedule() do
     Process.send_after(self(), :fetch_headlines_hourly, 1 * 60 * 60 * 1000) #check every hour for news updates/top stories
  end

  defp get_headlines(sources,number_of_headlines) do
# go through each source for their source (the id)
    sources
    |> Enum.map(&build_url(@default_news_url,&1)) #make the query strings
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end)) # make the get requests
    |> Enum.map(&Task.await/1)
  end

#  defp filter_feed(articles,number_of_headlines) do
#    articles
#    |>
#  end

#  def parse_responses(responses)do
#    responses
#    |> Enum.map(&Poison.decode!(&1, as: %{articles: [%News{}]}))
#
#  end

  defp parse_json({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Poison.decode!(as: %{"articles" => [%News{}]})
  end

  defp parse_json(error) do
#    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_parse_json, [])
  end


  defp build_url(url, network) do
#  not all sortBys's are available for each network.
    query = "#{url}&apiKey=#{api_key()}&source=#{network.id}&sortBy=#{List.first(network.sortBysAvailable)}"
    query
  end

  defp api_key do
    Application.get_env(:bullsource, :news_api)[:api_key]
  end

end