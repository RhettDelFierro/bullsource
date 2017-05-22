defmodule Bullsource.Web.Context do
  @behaviour Plug
  import Plug.Conn
  alias Bullsource.Accounts.User

  def init(opts), do: opts

  def call(conn, _ ) do
    case build_context(conn) do
      {ok, context} ->
        put_private(conn, :absinthe, %{context: context})
      {:error, reason} ->
        conn
      _ ->
        conn
    end
  end

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
      {:ok, resource}  -> {:ok, resource}
      {:error, reason} -> {:error, reason}
    end
  end
end