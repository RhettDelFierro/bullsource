defmodule Bullsource.Web.PageController do
  use Bullsource.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
