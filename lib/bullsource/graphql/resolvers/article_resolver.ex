defmodule Bullsource.GraphQL.ArticleResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a Post.
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Article}

  def list(_args, _context) do
    {:ok, Repo.all(Article)}
  end

  def assoc(_args, %{source: proof} = context) do
    proof = Repo.get_by(Article,proof_id: proof.id)
    {:ok, proof}
  end

# redo this function:
# do we need to look up for a reference first?
#  def create(%{reference: reference, proof_id: proof_id}, _context) do
#    {:ok, reference} = Discussion.get_or_insert_reference(reference)
#    proof = Repo.insert! %Article{proof_id: proof_id, reference_id: reference.id}
#    {:ok, proof}
#  end

 # for batch queries
 # maybe can use for getting all articles quoting a reference instead
  def by_proof_id(_, ids) do
    Article
    |> where([a], a.proof_id in ^ids)
    |> Repo.all
    |> Enum.group_by(&(&1.proof_id))
  end
end