defmodule Bullsource.Web.VoteController do
  use Bullsource.Web, :controller

  import Bullsource.Votes
  alias Bullsource.Helpers.Converters


  def create(conn,%{"post_vote" => post_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(post_vote)

    vote_handler conn, params, func_down: &down_vote_post/1, func_up: &up_vote_post/1
  end

  def create(conn,%{"proof_vote" => proof_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(proof_vote)

    vote_handler conn, params, func_down: &down_vote_proof/1, func_up: &up_vote_proof/1
  end

  def create(conn,%{"reference_vote" => reference_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(reference_vote)

    vote_handler conn, params, func_down: &down_vote_reference/1, func_up: &up_vote_reference/1
  end
#  this one will get called if the user already voted. this is where we'll repo.get, delete it then create a new vote in the other table.
  def update(conn, params) do

  end

  defp vote_handler(conn, params,func_list) do
    case params.vote_type do
      "down" ->

        with {:ok, new_vote} <- func_list[:func_down].(params) do
           render conn, "show.json", new_vote: new_vote
        else
         {:error, reason} ->
           render conn, ErrorView, "error.json", changeset_error: reason
        end

      "up"   ->
        with {:ok, new_vote} <- func_list[:func_up].(params)do
           render conn, "show.json", new_vote: new_vote
        else
         {:error, reason} ->
           render conn, ErrorView, "error.json", changeset_error: reason
        end

    end

  end
end