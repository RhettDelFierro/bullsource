defmodule Bullsource.Web.UserController do
  use Bullsource.Web, :controller
  alias Bullsource.Accounts
  alias Bullsource.Web.ErrorView


  def create(conn, %{"user" => user}) do
    case Accounts.create_user(user) do
      {:ok, user} ->
        render conn,"show.json", user: user
      {:error, user_changeset} ->
        render conn, ErrorView, "error.json", changeset_error: user_changeset
    end

  end

end