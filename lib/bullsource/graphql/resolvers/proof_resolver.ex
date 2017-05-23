defmodule Bullsource.GraphQL.ProofResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a Post.
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Proof}

  def list(_args, _context) do
    {:ok, Repo.all(Proof)}
  end

  def assoc(_args, %{source: post} = context) do
    IO.puts "++++++++assoc++++++++++"
    #now we're only making one query for all the Proofs in the Post:
    batch {__MODULE__, :by_post_id}, post.id, fn results ->
        {:ok, Map.get(results, post.id)}
    end
#    topic = Repo.preload(topic, :Posts)
#    {:ok, topic.Posts}
  end

# redo this function:
# do we need to look up for a reference first?
  def create(%{reference: reference, post_id: post_id}, _context) do
    {:ok, reference} = Discussion.get_or_insert_reference(reference)
    proof = Repo.insert! %Proof{post_id: post_id, reference_id: reference.id}
    {:ok, proof}
  end

  def by_post_id(_, ids) do
    Proof
    |> where([p], p.post_id in ^ids)
    |> Repo.all
    |> Enum.group_by(&(&1.post_id))
  end
end