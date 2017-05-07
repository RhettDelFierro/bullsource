defmodule Bullsource.Web.PostView do
# for api/user_controller.ex
  use Bullsource.Web, :view
  import Bullsource.Web.UserView, only: [user_json: 1]

  def render("show.json", %{post: post}) do
    %{ post: post_json(post) }
  end

  def post_json(post) do
    %{
      id: post.id,
      user: user_json(post.user),
      inserted_at: post.inserted_at,
      updated_at: post.updated_at,
      intro: post.intro,
      proofs: Enum.map(post.proofs, &proofs_json(&1))
    }
  end

  defp proofs_json(proof) do
      %{
        id: proof.id,
        article: proof.article.text,
        comment: proof.comment.text,
        reference: reference_json(proof.reference)
      }
  end

  defp reference_json(reference) do
    %{title: reference.title, link: reference.link}
  end

end