defmodule Bullsource.Web.UserController do
  use Bullsource.Web, :controller
  alias Bullsource.Accounts
  alias Messengyr.Web.ErrorView

  #
  action_fallback Bullsource.Web.FallbackController

  def create(conn, %{"user" => user}) do
    case Accounts.create_user(user) do
      {:ok, user} -> render(conn,"show.json", user: user)
      {:error, user_changeset} -> render(conn,"error.json", user_changeset: user_changeset)
    end

  end

  end

end