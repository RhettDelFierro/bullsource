defmodule Bullsource.Web.VoteController do
  use Bullsource.Web, :controller

  alias Bullsource.Votes
  alias BullSource.Votes.{PostVoteDown, PostVoteUp, ProofVoteDown,
                          ProofVoteUp, ReferenceVoteDown, ReferenceVoteDown}
  alias Bullsource.Helpers.Converters


  def create(conn,{"post_vote" = post_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(post_vote)


  end

  def create(conn,{"proof_vote" = proof_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(proof_vote)


  end

  def create(conn,{"reference_vote" = reference_vote}) do
    user = Guardian.Plug.current_resource(conn)
    params = Converters.str_to_atom_keys(reference_vote)


  end

end