defmodule Bullsource.Web.UserController do
  use Bullsource.Web, :controller
  alias Bullsource.Accounts
  alias Bullsource.Web.ErrorView

  #when a user registers.
  def create(conn, %{"user" => user}) do
    case Accounts.create_user(user) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")

        render new_conn, "show.json", user: user, jwt: jwt, exp: exp

      {:error, user_changeset} ->
        render conn, ErrorView, "error.json", changeset_error: user_changeset
    end

  end

end