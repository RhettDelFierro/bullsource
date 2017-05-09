defmodule Bullsource.Votes do
    import Ecto.{Changeset, Query}

    alias Bullsource.Accounts.User
    alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
    alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                              ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}
    alias Bullsource.Repo
    alias Ecto.Multi

    def down_vote_post(%{post_id: post_id, user: user}) do

    end

    def up_vote_post(%{post_id: post_id, user: user}) do

    end

    def down_vote_proof(%{proof_id: proof_id, user: user}) do

    end

    def up_vote_proof(%{proof_id: proof_id, user: user}) do

    end

    def down_vote_reference(%{reference_id: reference_id, user: user}) do

    end

    def up_vote_reference(%{reference_id: reference_id, user: user}) do

    end

    def change_vote(struct, user) do

    end

    ####Changesets
    def down_vote_post_changeset(params \\%{}) do
      %PostVoteDown{}
      |> cast(params, [:post_id, :user_id])
      |> validate_required([:post_id, :user_id])
      |> assoc_constraint(:user)
      |> assoc_constraint(:post)
    end

    def up_vote_post_changeset(params \\%{}) do
      %PostVoteUp{}
      |> cast(params, [:post_id, :user_id])
      |> validate_required([:post_id, :user_id])
      |> assoc_constraint(:user)
      |> assoc_constraint(:post)
    end

    def down_vote_proof_changeset(params \\%{}) do
      %ProofVoteDown{}
      |> cast(params, [:proof_id, :user_id])
      |> validate_required([:proof_id, :user_id])
      |> assoc_constraint(:user)
      |> assoc_constraint(:proof)

    end

    def up_vote_proof_changeset(params \\%{}) do
      %ProofVoteUp{}
      |> cast(params, [:proof_id, :user_id])
      |> validate_required([:proof_id, :user_id])
      |> assoc_constraint(:user)
      |> assoc_constraint(:proof)

    end

    def down_vote_reference_changeset(params \\%{}) do
      %ReferenceVoteDown{}
      |> cast(params, [:reference_id, :user_id])
      |> validate_required([:reference_id, :user_id])
      |> assoc_constraint(:user)
      |> assoc_constraint(:reference)

    end

    def up_vote_reference_changeset(params \\%{}) do
      %ReferenceVoteUp{}
      |> cast(params, [:reference_id, :user_id])
      |> validate_required([:reference_id, :user_id])
      |> assoc_constraint(:user)
      |> assoc_constraint(:reference)

    end


end