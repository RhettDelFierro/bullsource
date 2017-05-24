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

  def list(_args, _context) do
    {:ok, Repo.all(Post)}
  end

# think you'll have to hardcode this for votes - proofs, posts and references are all of it's parents for their respecting up/down votes.
# vote_type will either be post, proof or reference - for now.
#  def assoc(args, %{source: proof} = context) do
#    #args will be :id, :vote_type
#    #now we're only making one query for all the Posts int he topic:
#    batch {__MODULE__, :by_id, args.vote_type}, schema.id, fn results ->
#        {:ok, Map.get(results, vote_object.id)}
#    end
##   topic = Repo.preload(topic, :Posts)
##    {:ok, topic.Posts}
#  end

  def create(%{vote_type: vote_type, vote_type_id: vote_type_id} = args, %{context: %{current_user: current_user}}) do
     vote_params = %{id: vote_type_id, user_id: current_user.id}
     with {:ok, vote} <- Votes.create_vote(vote_type, vote_params)
     do
       {:ok, vote}
     else
       {:error, errors} -> {:error, errors}
     end
  end

# ids are thread_ids
  def by_id(vote_type, ids) do
    @vote_type_list[vote_type]
    |> where([v], v.thread_id in ^ids)
    |> Repo.all
    |> Enum.group_by(&(&1.thread_id))
  end
end