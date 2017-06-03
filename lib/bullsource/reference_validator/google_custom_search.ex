defmodule Bullsource.ReferenceValidator.GoogleCustomSearch do

  def start_link(url, url_ref, owner, limit) do
    Task.start_link(__MODULE__, :get_info, [url, url_ref, owner, ])
  end

  defp get_info(url) do
    {:ok, url}
  end
end