defmodule BullSource.News.GetNews do
  use GenServer

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
    state = get_articles()
    set_schedule()
    {:ok, state}
  end

  def handle_call(:get_news, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch, state) do

    set_schedule() # Reschedule once more
    {:noreply, state}
  end

  ###
  # Private functions
  ###

  defp set_schedule() do
     Process.send_after(self(), :fetch, 1 * 60 * 60 * 1000) #check every hour for news updates/top stories
  end

  defp get_sources() do

  end

  defp get_articles() do

  end

  defp api_key do
    Application.get_env(:bullsource, :news_api)[:api_key]
  end

end