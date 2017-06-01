defmodule Bullsource.GraphQL.PostResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [create_post: 2, edit_post: 1]
  alias Bullsource.{Repo, Discussion.Post}


  def list(_args, _context), do: {:ok, Repo.all(Post)}



  def create(%{thread_id: thread_id, post: post}, %{context: %{current_user: current_user}}) do
     post_params = Map.put_new(post, :thread_id, thread_id)

     case create_post(post_params, current_user) do
       {:ok, post} -> {:ok, post}
       {:error, errors} -> {:error, errors}
     end

  end




  def edit(args,%{context: %{current_user: current_user}}) do
    %{post_id: post_id,intro: intro} = args
    post_info = %{id: post_id, intro: intro, user_id: current_user.id}

    case edit_post(post_info) do
      {:ok, post} -> {:ok, post}
      {:error, error} -> {:error, error}
    end

  end



end