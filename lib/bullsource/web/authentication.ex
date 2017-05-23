defmodule Bullsource.Web.Authentication do
  @behaviour Absinthe.Middleware

# this will short circuit the query/mutation if no current_user is found.
  def call(resolution, _config) do

    #check if there is a current_user in context:
    case resolution.context do
      %{current_user: _} ->
        resolution
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, %{code: :not_authenticated,
                                                     error: "Not authenticated.",
                                                     message: "Not authenticated"}})
    end
  end
end