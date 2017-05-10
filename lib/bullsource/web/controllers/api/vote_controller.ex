defmodule Bullsource.Web.VoteController do
  use Bullsource.Web, :controller

  alias Bullsource.Votes
  alias Bullsource.Helpers.Converters


  def create(conn,%{"post_vote" => post_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(post_vote)
    case params.vote_type do
      "down" ->
        Votes.down_vote_post(params)
      "up"   ->
        Votes.up_vote_post(params)
    end

  end

  def create(conn,%{"proof_vote" => proof_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(proof_vote)
    IO.inspect params

  end

  def create(conn,%{"reference_vote" => reference_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(reference_vote)
    IO.inspect params

  end
#  this one will get called if the user already voted. this is where we'll repo.get, delete it then create a new vote in the other table.
  def update(conn, params) do

  end

  defp render_vote(tuple,conn) do
    case tuple do
      {:ok, changeset} ->
      {:ok, error_changeset} ->
    end
  end
end