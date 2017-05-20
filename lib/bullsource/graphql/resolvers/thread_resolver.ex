defmodule Bullsource.GraqphQL.ThreadResolver do
  alias Bullsource.Repo
      alias Bullsource.Discussion.{Article, Comment, Post, Proof, Reference, Thread, Topic}
      alias Bullsource.Accounts.User
      alias Bullsource.Votes.{PostVoteUp, PostVoteDown, ProofVoteUp,
                                      ProofVoteDown, ReferenceVoteUp, ReferenceVoteDown}

      def assoc(_args, %{source: topic}) do
        topic = Repo.preload(topic, :threads)
        {:ok, topic.threads}
      end

      def create(%{title: title, topic_id: topic_id}, _context) do
        thread = Repo.insert! %Thread{title: title, topic_id: topic_id}
        {:ok, thread}
      end
end