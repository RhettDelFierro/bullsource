defmodule Bullsource.ReferenceValidator.GoogleCustomSearch do
  @google_url "https://www.googleapis.com/customsearch/v1?"

  def start_link(url, url_ref, owner, limit) do
    Task.start_link(__MODULE__, :get_info, [url, url_ref, owner, limit])
  end

  defp get_info(url, url_ref, owner, limit) do
    url
    |> build_query
    |> make_request
    |> send_results(query_ref, owner)
  end

  defp build_query(url) do
    api_key = build_api_key()
    query = @google_url <> "key=#{api_key}" <> "&q=#{url}"
    query
  end

  defp build_api_key do
    Application.get_env(:bullsource, :google_custom_search)[:app_id]
  end

  defp make_request(query) do
    case HTTPoison.get(query) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
         {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
         {:error, "404 error"}
      {:error, %HTTPoison.Error{reason: reason}} ->
         {:error, reason}
    end
  end

  defp send_results(answer, query_ref, owner) do
    results = [%Result{result: to_string(answer)}]
    send(owner, {:results, query_ref, results})
  end

end