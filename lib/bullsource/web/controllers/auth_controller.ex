defmodule Bullsource.Web.AuthController do
  use Bullsource.Web, :controller
  alias Bullsource.Web.ErrorView

  #for use with Guardian dependency.
  def unauthenticated(conn, _params) do
    render conn, ErrorView, "error.json", message: "You must be logged in to perform this action."
  end
end