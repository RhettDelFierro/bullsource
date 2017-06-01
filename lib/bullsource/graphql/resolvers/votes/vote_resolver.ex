defmodule Bullsource.GraphQL.VoteResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a Post.
  import Ecto.Query

  alias Bullsource.{Repo, Votes}
  alias Bullsource.Account.User
  alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                    ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}



  @vote_type_list [up_vote_post: PostVoteUp,
                   down_vote_post: PostVoteDown,
                   up_vote_proof: ProofVoteUp,
                   down_vote_proof: ProofVoteDown,
                   up_vote_reference: ReferenceVoteUp,
                   down_vote_reference: ReferenceVoteDown]



  def list(_args, _context), do: {:ok, Repo.all(Post)}


  def create(%{vote_type: vote_type, vote_type_id: vote_type_id} = args, %{context: %{current_user: current_user}}) do
    vote_params = %{id: vote_type_id, user_id: current_user.id}

    with {:ok, vote} <- Votes.create_vote(vote_type, vote_params)
    do
    # how to return the vote of vote so GraphQL can understand which vote type it was?
      {:ok, vote}
    else
      {:error, errors} -> {:error, errors}
    end

  end


end