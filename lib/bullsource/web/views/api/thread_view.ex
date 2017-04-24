defmodule Bullsource.Web.ThreadView do
# for api/user_controller.ex
  use Bullsource.Web, :view

  def render("index.json", %{threads: threads}) do
    %{
      threads: Enum.map(threads, &thread_json(&1))
    }
  end

  def render("show.json", %{thread: thread}) do
    %{ thread: thread_json(thread) }
  end

  defp thread_json(thread) do
    %{
      id: thread.id,
      created_by: thread.user.username,
      created_at: thread.inserted_at,
      title: thread.title
    }
  end

end