defmodule Bullsource.Web.Context do
  @behaviour Plug
  import Plug.Conn
  alias Bullsource.Accounts.User


#  interface functions for Plug
  def init(opts), do: opts

  def call(conn, _ ) do
    case build_context(conn) do
      {ok, context} ->
      #  we stuff the resulting context into our conn, as is expected by Absinthe (see http://absinthe-graphql.org/guides/context-and-authentication/#context-and-plugs)
        put_private(conn, :absinthe, %{context: context}) #put_private is on Plug.Conn and sets context values which Absinthe.Plug will pass it along to Absinthe.run.
                                                           #like so:
                                                           # Absinthe.run(document, Bullsource.GraphQL.Schema, context: %{current_user: %{id: "1"}})
                                                             # the current_user is built with __MODULE__.build_context/1
                                                               #left with %{context: %{current_user: current_user}}
                                                                 # %{context: %{
                                                                 #              current_user: %{id: 1,...}
                                                                 #             }
                                                                 # }
      {:error, reason} ->
        conn
        |> send_resp(403, reason)
        |> halt()

      _ ->
        conn
        |> send_resp(400, "Bad Request")
        |> halt()

    end
  end

# building our GraphQL context.
  defp build_context(conn) do
    with ["Bearer" <> token] <- get_req_header(conn, "Authorization"),
    {:ok, current_user} <- authorize(token) do
      {ok, %{current_user: current_user}}
    end
  end

  defp authorize(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims}    -> return_user(claims)
      {:error, reason} -> {error, reason}
    end
  end

  defp return_user(claims) do
    case Guardian.serializer.from_token(Map.get(claims, "sub")) do
      {:ok, resource}  -> {:ok, resource} #resource is %{current_user: current_user} (see __MODULE.build_context/1)
      {:error, reason} -> {:error, reason}
    end
  end
end