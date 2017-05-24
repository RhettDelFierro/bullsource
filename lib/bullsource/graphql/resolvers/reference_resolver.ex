defmodule Bullsource.GraphQL.ReferenceResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a Post.
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Reference}

  def list(_args, _context) do
    {:ok, Repo.all(Reference)}
  end

  #if anything another funciton you need is:
  def get_reference_by_id(args,context) do
    {:ok, Repo.get_by(Reference,id: args.id)}
  end

# redo this function:
# do we need to look up for a reference first?
#  def create(%{reference: reference, post_id: post_id}, _context) do
#    {:ok, reference} = Discussion.get_or_insert_reference(reference)
#    proof = Repo.insert! %Proof{post_id: post_id, reference_id: reference.id}
#    {:ok, proof}
#  end

# don't think you need a by_parent_id/2 function this because reference isn't a child to anything.

end