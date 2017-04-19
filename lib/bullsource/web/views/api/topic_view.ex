defmodule Bullsource.Web.TopicView do
# for api/user_controller.ex
  use Bullsource.Web, :view

  def render("index.json", %{topics: topics}) do
    %{topics: topics}
  end

  def render("show.json", %{topic: topic}) do
    %{topic: topic_json(topic)}
  end

  defp topic_json(topic) do
    %{
      id: topic.id,
      name: topic.name,
      description: topic.description
    }
  end

end