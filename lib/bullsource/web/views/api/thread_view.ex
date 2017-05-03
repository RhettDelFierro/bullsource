defmodule Bullsource.Web.ThreadView do
# for api/user_controller.ex
  use Bullsource.Web, :view
  import Bullsource.Web.PostView, only: [post_json: 1]

  def render("index.json", %{threads: threads}) do
    %{
      threads: Enum.map(threads, &thread_json(&1))
    }
  end

  def render("show.json", %{new_thread: new_thread}) do
    %{ thread: thread_json(new_thread) }
  end

  defp thread_json(thread) do
    %{
      id: thread.id,
      created_by: thread.user.username,
      created_at: thread.inserted_at,
      title: thread.title,
      posts: Enum.map thread.posts &post_json(&1)
    }
  end

end