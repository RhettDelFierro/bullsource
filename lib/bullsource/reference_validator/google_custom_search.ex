defmodule Bullsource.ReferenceValidator.GoogleCustomSearch do
  @google_url "https://www.googleapis.com/customsearch/v1?"

  alias Bullsource.ReferenceValidator.Result

  def start_link(url, url_ref, owner, limit) do
    Task.start_link(__MODULE__, :get_info, [url, url_ref, owner, limit])
  end

  def get_info(url, url_ref, owner, limit) do
    url
    |> build_query
    |> make_request
    |> parse_json
    |> send_results(url_ref, owner)
  end

  defp build_query(url) do
    api_key = build_api_key()
    cx = Application.get_env(:bullsource, :google_custom_search)[:context]
    query = @google_url <> "key=#{api_key}" <> "&q=#{url}" <> "&cx=#{cx}"
#    IO.puts query
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

  defp parse_json(answer) do
    case answer do
      {:ok, body} ->
#        Poison.Parser.parse!(body, keys: :atoms!)
         body
         |> Poison.decode!
         |> Bullsource.Helpers.Converters.str_to_atom_keys
      _ -> nil
    end
  end

  defp send_results(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end


  defp send_results(answer, query_ref, owner) do
    IO.inspect answer
    results = [%Result{result: answer}] #I want Result.result to be a List.
    send(owner, {:results, query_ref, results})
  end

end