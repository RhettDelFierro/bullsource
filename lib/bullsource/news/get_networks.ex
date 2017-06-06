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

  @default_networks_url "https://newsapi.org/v1/sources?language=en"
  def init(_state) do
    #get sources from the other GetNetworks
    state = build_url(@default_networks_url)
    |> HTTPoison.get([], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    |> parse_json
    set_schedule()
    {:ok, state}
  end

  def handle_call(:get_networks, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch, state) do
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

  defp build_url(url) do
    url
  end

  defp parse_json({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
#    body |> Poison.decode!(keys: :atoms!)
    body |> Poison.decode!(as: %{sources: [%Network{}]})
  end

  defp parse_json(error) do
    IO.puts "========ERROR: #{inspect error}"
    Process.send(self(),:error_parse_json, [])
  end

end