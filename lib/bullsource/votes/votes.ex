defmodule Bullsource.Votes do
  import Ecto.{Changeset, Query}
  alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
  alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                            ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}
  alias Bullsource.Repo



  @vote_type_opposites [up_vote_post: %PostVoteDown{},   down_vote_post: %PostVoteUp{},
                        up_vote_proof: %ProofVoteDown{}, down_vote_proof: %ProofVoteUp{},
                        up_vote_reference:   %ReferenceVoteDown{}, down_vote_reference: %ReferenceVoteUp{}
                       ]



 # this also takes care of deleting votes from the opposite table
  def create_vote(func, params) do
    opposite_vote_type = @vote_type_opposites[func]
    case DeleteVote.delete_vote(opposite_vote_type,%{id: params.id, user_id: params.user_id}) do
      {:ok, _ } ->
        apply(__MODULE__, func, [params]) |> Repo.insert
      {:error, error_changeset} ->
        {:error, error_changeset}
    end
  end


  def down_vote_post(params),
    do: down_vote_post_changeset(%PostVoteDown{},%{post_id: params.id, user_id: params.user_id})
  def up_vote_post(params),
    do: up_vote_post_changeset(%PostVoteUp{},%{post_id: params.id, user_id: params.user_id})
  def down_vote_proof(params),
    do: down_vote_proof_changeset(%ProofVoteDown{},%{proof_id: params.id, user_id: params.user_id})
  def up_vote_proof(params),
    do: up_vote_proof_changeset(%ProofVoteUp{},%{proof_id: params.id, user_id: params.user_id})
  def down_vote_reference(params),
    do: down_vote_reference_changeset(%ReferenceVoteDown{},%{reference_id: params.id, user_id: params.user_id})
  def up_vote_reference(params),
    do: up_vote_reference_changeset(%ReferenceVoteUp{},%{reference_id: params.id, user_id: params.user_id})




#### Changesets
  defp down_vote_post_changeset(struct,params \\%{}) do
    struct
    |> cast(params, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
    |> unique_constraint(:post_id, name: :post_votes_down_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:post)
  end

  defp up_vote_post_changeset(struct,params \\%{}) do
    struct
    |> cast(params, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
    |> unique_constraint(:post_id, name: :post_votes_up_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:post)
  end

  defp down_vote_proof_changeset(struct,params \\%{}) do
    struct
    |> cast(params, [:proof_id, :user_id])
    |> validate_required([:proof_id, :user_id])
    |> unique_constraint(:proof_id, name: :proof_votes_down_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:proof)
  end

  defp up_vote_proof_changeset(struct,params \\%{}) do
    struct
    |> cast(params, [:proof_id, :user_id])
    |> validate_required([:proof_id, :user_id])
    |> unique_constraint(:proof_id, name: :proof_votes_up_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:proof)
  end

  defp down_vote_reference_changeset(struct,params \\%{}) do
    struct
    |> cast(params, [:reference_id, :user_id])
    |> validate_required([:reference_id, :user_id])
    |> unique_constraint(:reference_id, name: :reference_votes_down_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:reference)
  end

  defp up_vote_reference_changeset(struct,params \\%{}) do
    struct
    |> cast(params, [:reference_id, :user_id])
    |> validate_required([:reference_id, :user_id])
    |> unique_constraint(:reference_id, name: :reference_votes_up_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:reference)
  end

end