defmodule Bullsource.Web.SessionController do
  use Bullsource.Web, :controller
  alias Bullsource.Accounts.Session
  alias Bullsource.Web.ErrorView

  #logging in the user
  def create(conn, %{"user" => user}) do
    case Session.authenticate(user) do
      {:ok, user} ->
         new_conn = Guardian.Plug.api_sign_in(conn, user)
         jwt = Guardian.Plug.current_token(new_conn)
         {:ok, claims} = Guardian.Plug.claims(new_conn)
         exp = Map.get(claims, "exp")

         render new_conn, "show.json", user: user, jwt: jwt, exp: exp
      {:error, message} ->
        conn
        |> put_status(401)
        |> render(ErrorView, "error.json", message: message)
    end
  end

end