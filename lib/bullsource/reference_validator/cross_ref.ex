defmodule Bullsource.ReferenceValidator.CrossRef do
  @crossref_url "https://api.crossref.org/works?"

  alias Bullsource.ReferenceValidator.Result

  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :get_info, [query, query_ref, owner, limit])
  end

  def get_info(query, query_ref, owner, limit) do
    query
    |> build_query
    |> make_request
    |> parse_json
    |> send_results(query_ref, owner)
  end

  defp build_query(query) do

#    str = String.replace(match_text," ","+")
    @crossref_url <> "query=#{URI.encode(query)}"
  end

  defp build_jwt_token do
    Application.get_env(:bullsource, :jstor)[:jwt]
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