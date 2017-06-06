defmodule Bullsource.News.GetNetworks do
  use GenServer

  defmodule Network do
    defstruct id: nil,
              name: nil,
              description: nil,
              url: nil,
              category: nil,
              language: nil,
              country: nil,
              urlsToLogos: %{
                             small: nil,
                             medium: nil,
                             large: nil
                           },
              sortBysAvailable: []
  end

  #

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
    state = get_networks()
    set_schedule()
    {:ok, state}
  end

  def handle_call(:get_networks, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch, state) do
    state = get_networks()
    set_schedule() # Reschedule once more
    {:noreply, state}
  end








  ###
  # Private functions
  ###

  defp set_schedule() do
     Process.send_after(self(), :fetch, 1 * 60 * 60 * 24 *1000) #check every day
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

  @default_networks_url "https://newsapi.org/v1/sources?language=en"

  defp get_networks() do
    case HTTPoison.get(@default_networks_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
         {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
         IO.puts "+++++++++status code 404+++++++++++"
         nil
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "error #{inspect reason}"
         nil
      what_happend ->
      #%HTTPoison.Response{body: "{\n \"error\": {\n  \"errors\": [\n   {\n
        IO.puts "+++++++++++OFF++++++++++++ #{inspect what_happend}"
        nil
    end
  end

  defp parse_response(response) do

  end

  defp get_articles() do

  end
end