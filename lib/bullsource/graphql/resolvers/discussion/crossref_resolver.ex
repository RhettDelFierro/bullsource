defmodule Bullsource.GraphQL.DOIResolver do

  import Bullsource.ReferenceValidator,only: [verify_doi: 2]

  def check_doi(%{doi: doi} = args, _context) do
    case verify_doi(doi, []) do
      [] -> {:error, %{message: "This is not a valid doi"}}
      works -> {:ok, works}
    end

  end
end