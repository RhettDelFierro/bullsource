defmodule Bullsource.Web.PostView do
# for api/user_controller.ex
  use Bullsource.Web, :view

  def post_json(post) do
    %{
      id: post.id,
      inserted_at: post.inserted_at,
      intro: post.intro,
      proofs: Enum.map(post.proofs, &proofs_json(&1))
    }
  end

  defp proofs_json(proof) do
      %{
        id: proof.id,
        article: proof.article.text,
        comment: proof.comment.text,
        reference: Enum.map(proof.references, &references_json(&1))
      }
  end

  defp references_json([]) do
    []
  end

  defp references_json([r | rs]) do
    [%{title: r.title, link: r.link}] ++ references_json(rs)
  end

end