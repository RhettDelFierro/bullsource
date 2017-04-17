defmodule Bullsource.Web.UserView do
# for api/user_controller.ex
  use Bullsource.Web, :view

  def render("show.json", %{user: user}) do
    %{
      user: user_json(user)
    }
  end

  defp user_json(user) do
    %{
      id: user.id,
      username: user.username,
    }
  end

end