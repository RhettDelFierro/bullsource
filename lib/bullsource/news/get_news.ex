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
#      |> Enum.map(&parse_json(&1))
#      |> List.flatten
#      |> Enum.map(&Bullsource.Helpers.Converters.str_to_atom_keys(&1))
#      |> Enum.map(&Enum.take(&1.articles,3))
  end

  defp set_schedule() do
     Process.send_after(self(), :fetch_headlines_hourly, 1 * 60 * 60 * 1000) #check every hour for news updates/top stories
  end

  defp api_key do
    Application.get_env(:bullsource, :news_api)[:api_key]
  end

  defp build_url(url, network) do
#  not all sortBys's are available for each network.
    query = "#{url}&apiKey=#{api_key()}&source=#{network.id}&sortBy=#{List.first(network.sortBysAvailable)}"
    query
  end

  defp get_headlines([], acc) do
    acc
  end

  defp get_headlines([n | ns], acc) do
    headline = build_url(@default_news_url,n)
    task = Task.async(fn -> HTTPoison.get(headline) end)
#    response = Task.await(task)

    get_headlines(ns, [{n, task} | acc])
  end

  defp format_list({network,task}) do
    %{"articles" => articles, "sortBy" => sortBy} = parse_json(Task.await(task))

    %{
      network: network,
      news: articles,
      sortBy: sortBy
     }
  end


#  defp get_headlines(sources,number_of_headlines) do
## go through each source for their source (the id)
#    sources
#    |> Enum.map(&build_url(@default_news_url,&1)) #make the query strings
#    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end)) # make the get requests
#    |> Enum.map(&Task.await/1)
#  end

  defp parse_json({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Poison.decode!(as: %{"articles" => [%News{}]})
  end

  defp parse_json(error) do
#    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_parse_json, [])
  end

end