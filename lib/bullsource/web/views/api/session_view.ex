defmodule Bullsource.Web.SessionView do
# for api/user_controller.ex
  use Bullsource.Web, :view

  def render("show.json", %{jwt: jwt, user: user, exp: exp}) do

    %{
      jwt: jwt,
      user: %{username: user.username, id: user.id},
      exp: exp
    }

  end

end