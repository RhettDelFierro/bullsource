#defprotocol Bullsource.DeleteVote do
#  @moduledoc "This protocol is used to Add and Delete Types from the Repo"
#
##  @doc "Add a type"
##  def add(type,params)
#  @spec delete(any,Map) :: Tuple
#  def delete(type,params)
#end
#
#defimpl Bullsource.DeleteVote, for: Bullsource.Votes.PostVoteUp do
#  @spec delete(Bullsource.Votes.PostVoteUp,Map) :: Tuple
#  def delete(post_vote_up,params) do
#        query = from p in post_vote_up,
#                where: p.post_id == params.id and p.user_id == params.user_id
#        case Bullsource.Repo.one(query) do
#          nil -> {:ok, nil}
#          post -> Bullsource.Repo.delete(post)
#        end
#  end
#end
#
#defimpl Bullsource.DeleteVote, for: Bullsource.Votes.PostVoteDown do
#  @spec delete(Bullsource.Votes.PostVoteDown,Map) :: Tuple
#  def delete(post_vote_down,params) do
#        query = from p in post_vote_down,
#                where: p.post_id == ^params.id and p.user_id == ^params.user_id
#        case Bullsource.Repo.one(query) do
#          nil -> {:ok, nil}
#          post -> Bullsource.Repo.delete(post)
#        end
#  end
#end
#
#defimpl Bullsource.DeleteVote, for: Bullsource.Votes.ProofVoteUp do
#  @spec delete(Bullsource.Votes.ProofVoteUp,Map) :: Tuple
#  def delete(proof_vote_up,params) do
#        query = from p in proof_vote_up,
#                where: p.proof_id == ^params.id and p.user_id == ^params.user_id
#        case Bullsource.Repo.one(query) do
#          nil -> {:ok, nil}
#          proof -> Bullsource.Repo.delete(proof)
#        end
#  end
#end
#
#defimpl Bullsource.DeleteVote, for: Bullsource.Votes.ProofVoteDown do
#  @spec delete(Bullsource.Votes.ProofVoteDown,Map) :: Tuple
#  def delete(proof_vote_down,params) do
#        query = from p in proof_vote_down,
#                where: p.proof_id == ^params.id and p.user_id == ^params.user_id
#        case Bullsource.Repo.one(query) do
#          nil -> {:ok, nil}
#          proof -> Bullsource.Repo.delete(proof)
#        end
#  end
#end
#
#defimpl Bullsource.DeleteVote, for: Bullsource.Votes.ReferenceVoteUp do
#  @spec delete(Bullsource.Votes.ReferenceVoteUp,Map) :: Tuple
#  def delete(reference_vote_up,params) do
#        query = from r in reference_vote_up,
#                where: r.reference_id == ^params.id and r.user_id == ^params.user_id
#        case Bullsource.Repo.one(query) do
#          nil -> {:ok, nil}
#          reference -> Bullsource.Repo.delete(reference)
#        end
#  end
#end
#
#defimpl Bullsource.DeleteVote, for: Bullsource.Votes.ReferenceVoteDown do
#  @spec delete(Bullsource.Votes.ReferenceVoteDown,Map) :: Tuple
#  def delete(reference_vote_down,params) do
#        query = from r in reference_vote_down,
#                where: r.reference_id == ^params.id and r.user_id == ^params.user_id
#        case Bullsource.Repo.one(query) do
#          nil -> {:ok, nil}
#          reference -> Bullsource.Repo.delete(reference)
#        end
#  end
#end