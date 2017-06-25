defmodule Bullsource.ReferenceValidator.CrossRef do
  @crossref_url "https://api.crossref.org/works/"

  alias Bullsource.ReferenceValidator.Result.Work

  def start_link(doi, doi_ref, owner, limit) do
    Task.start_link(__MODULE__, :get_info, [doi, doi_ref, owner, limit])
  end

  def get_info(doi, doi_ref, owner, _limit) do
    doi
    |> build_query
    |> make_request
    |> parse_json
    |> send_results(doi_ref, owner)
  end

  defp build_query(query), do: @crossref_url <> "#{URI.encode(query)}"

  defp make_request(query) do
    case HTTPoison.get(query, [], [ ssl: [{:versions, [:'tlsv1.2']}] ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
         {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
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
         %{message: message} = body
           |> Poison.decode!
           |> Bullsource.Helpers.Converters.str_to_atom_keys()
           |> Bullsource.Helpers.Converters.change_map_keys("-","_")
           |> Bullsource.Helpers.Converters.change_map_keys("reference","reference_cite")
           |> Bullsource.Helpers.Converters.map_keys_to_lowercase()

         message
      _ -> nil
    end
  end

  defp send_results(nil, doi_ref, owner) do
    send(owner, {:results, doi_ref, []})
  end


  defp send_results(answer, query_ref, owner) do
    results = answer
    send(owner, {:results, query_ref, [results]})
  end

end