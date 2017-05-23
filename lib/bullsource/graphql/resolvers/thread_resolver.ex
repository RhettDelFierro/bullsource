defmodule Bullsource.GraphQL.ThreadResolver do
  import Absinthe.Resolution.Helpers #batch query so it won't make a query for each topic to get a thread.
  import Ecto.Query

  alias Bullsource.{Repo, Discussion, Discussion.Thread}

  def list(_args, _context) do
    {:ok, Repo.all(Thread)}
  end

  def assoc(_args, %{source: topic} = context) do
    #now we're only making one query for all the threads int he topic:
    batch {__MODULE__, :by_topic_id}, topic.id, fn results ->
        {:ok, Map.get(results, topic.id)}
    end
#    topic = Repo.preload(topic, :threads)
#    {:ok, topic.threads}
  end

#  def create(%{title: title, topic_id: topic_id, post: post}, %{current_user: current_user} = context) do
#    thread = Repo.insert! %Thread{title: title, topic_id: topic_id}
#    {:ok, thread}
#  end

   def create(params, %{context: %{current_user: current_user}}) do
     {post_params,thread_params} = Map.pop(params, :post)
#     new_thread_params = %{title: title, topic_id: topic_id}
#     new_post_params = %{intro: post.intro, proofs: post.proofs}
     with {:ok, posts} <- Discussion.create_thread(thread_params, post_params, current_user)
     do
       {:ok, posts}
     else
       {:error, errors} -> {:error, errors}
     end
   end

  def by_topic_id(_, ids) do
    Thread
    |> where([t], t.topic_id in ^ids)
    |> Repo.all
    |> Enum.group_by(&(&1.topic_id))
  end
end