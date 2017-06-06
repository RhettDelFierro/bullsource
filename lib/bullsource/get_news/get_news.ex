defmodule BullSource.GetNews do
  use GenServer

  ###
  # GenServer API
  ###
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    state = get_news()
    set_schedule()
    {:ok, state}
  end

  def handle_info(:fetch, state) do

    set_schedule() # Reschedule once more
    {:noreply, state}
  end

  ###
  # Private functions
  ###

  defp set_schedule() do
     Process.send_after(__MODULE__, :fetch, 1 * 60 * 60 * 1000) #check every hour for news updates/top stories
#    Process.send_after(self(), :work, 1 * 60 * 60 * 1000) #check every hour for news updates/top stories
  end

  defp get_news() do

  end
end