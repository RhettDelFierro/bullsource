defmodule Bullsource.Web.Context do
  @behaviour Plug
  import Plug.Conn
  alias Bullsource.Accounts.User

  def init(opts), do: opts

  def call(conn, _ ) do
    case build_context(conn) do
      {ok, context} ->
        put_private*conn, :absinthe, %{context: context}
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


end