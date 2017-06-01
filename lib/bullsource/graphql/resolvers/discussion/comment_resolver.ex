defmodule Bullsource.GraphQL.CommentResolver do
  import Ecto.Query

  import Bullsource.Discussion, only: [edit_comment: 1]
  alias Bullsource.{Repo, Discussion.Comment}



  def list(_args, _context), do: {:ok, Repo.all(Comment)}



  def edit(args, %{context: %{current_user: current_user}}) do

        %{comment_id: comment_id,text: text, post_id: post_id} = args

        comment_info =
          %{id: comment_id, text: text, post_id: post_id, user_id: current_user.id}


        case edit_comment(comment_info) do

          {:ok, comment} -> {:ok, comment}

          {:error, error} -> {:error, error}

        end

  end

end