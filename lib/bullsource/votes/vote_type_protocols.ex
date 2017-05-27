defprotocol DeleteVote do
  @moduledoc "This protocol is used to Add and Delete Types from the Repo"

#  @doc "Add a type"
#  def add(type,params)
  @fallback_to_any true
  def delete_vote(vote_type,_params)
end

defimpl DeleteVote, for: Bullsource.Votes.PostVoteUp do
  import Ecto.Query, only: [from: 2]
  def delete_vote(post_vote_up,params) do
        query = from p in Bullsource.Votes.PostVoteUp,
                where: p.post_id == ^params.id and p.user_id == ^params.user_id
        case Bullsource.Repo.one(query) do
          nil -> {:ok, nil}
          post -> Bullsource.Repo.delete(post)
        end
  end
end

defimpl DeleteVote, for: Bullsource.Votes.PostVoteDown do
  import Ecto.Query, only: [from: 2]
  def delete_vote(post_vote_down,params) do
        query = from p in Bullsource.Votes.PostVoteDown,
                where: p.post_id == ^params.id and p.user_id == ^params.user_id
        case Bullsource.Repo.one(query) do
          nil -> {:ok, nil}
          post -> Bullsource.Repo.delete(post)
        end
  end
end

defimpl DeleteVote, for: Bullsource.Votes.ProofVoteUp do
  import Ecto.Query, only: [from: 2]
  def delete_vote(proof_vote_up,params) do
        query = from p in Bullsource.Votes.ProofVoteUp,
                where: p.proof_id == ^params.id and p.user_id == ^params.user_id
        case Bullsource.Repo.one(query) do
          nil -> {:ok, nil}
          proof -> Bullsource.Repo.delete(proof)
        end
  end
end

defimpl DeleteVote, for: Bullsource.Votes.ProofVoteDown do
  import Ecto.Query, only: [from: 2]
  def delete_vote(proof_vote_down,params) do
        query = from p in Bullsource.Votes.ProofVoteDown,
                where: p.proof_id == ^params.id and p.user_id == ^params.user_id
        case Bullsource.Repo.one(query) do
          nil -> {:ok, nil}
          proof -> Bullsource.Repo.delete(proof)
        end
  end
end

defimpl DeleteVote, for: Bullsource.Votes.ReferenceVoteUp do
  import Ecto.Query, only: [from: 2]
  def delete_vote(reference_vote_up,params) do
        query = from r in Bullsource.Votes.ReferenceVoteUp,
                where: r.reference_id == ^params.id and r.user_id == ^params.user_id
        case Bullsource.Repo.one(query) do
          nil -> {:ok, nil}
          reference -> Bullsource.Repo.delete(reference)
        end
  end
end

defimpl DeleteVote, for: Bullsource.Votes.ReferenceVoteDown do
  import Ecto.Query, only: [from: 2]
  def delete_vote(reference_vote_down,params) do
        query = from r in Bullsource.Votes.ReferenceVoteDown,
                where: r.reference_id == ^params.id and r.user_id == ^params.user_id
        case Bullsource.Repo.one(query) do
          nil -> {:ok, nil}
          reference -> Bullsource.Repo.delete(reference)
        end
  end
end

defimpl DeleteVote, for: Any do
  import Ecto.Query, only: [from: 2]
  def delete_vote(blah,params) do
        {:ok, blah}
  end
end