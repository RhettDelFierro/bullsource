defmodule Bullsource.GraphQL.ThreadResolver do
  import Ecto.Query

  alias Bullsource.{Repo, Discussion.Thread}
  import Bullsource.Discussion, only: [create_thread: 3]

  def list(_args, _context) do
    {:ok, Repo.all(Thread)}
  end



  def create(args, %{context: %{current_user: current_user}} = context) do
    {post_params,thread_params} = Map.pop(args, :post)
    with {:ok, thread} <- create_thread(thread_params, post_params, current_user)
    do
      {:ok, thread}
    else
       {:error, errors} -> {:error, errors}
    end
  end


end