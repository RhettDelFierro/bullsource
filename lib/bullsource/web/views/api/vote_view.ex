defmodule Bullsource.Web.VoteView do
# for api/user_controller.ex
  use Bullsource.Web, :view

  def render("show.json", %{new_vote: new_vote}) do
    %{ new_vote_id: new_vote.id }
  end

end