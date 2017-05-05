defmodule Bullsource.Web.UserView do
# for api/user_controller.ex
  use Bullsource.Web, :view


  def render("show.json", %{jwt: jwt, user: user, exp: exp}) do
    %{
      jwt: jwt,
      user: user_json(user),
      exp: exp
    }
  end

  def user_json(user) do
    %{
      id: user.id,
      username: user.username,
    }
  end

end