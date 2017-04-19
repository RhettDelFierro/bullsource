defmodule Bullsource.Web.TopicController do
  use Bullsource.Web, :controller

  def index(conn, _params) do
    conn |> text "yo!"
  end

  def create(conn, params) do
    conn |> text "yessir"
  end
end