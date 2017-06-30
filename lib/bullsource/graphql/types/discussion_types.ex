defmodule Bullsource.GraphQL.Types.DiscussionTypes do
  use Absinthe.Ecto, repo: Bullsource.Repo
  use Absinthe.Schema.Notation

  @desc "Topics has many headlines."
  object :topic do
    field :id, :integer
    field :name, :string
    field :description, :string

    #because :topic has_many :headlines, we're going to add a :headlines field
    field :headlines, list_of(:headline), resolve: assoc(:headlines)
  end

  @desc "Headlines belong to topics and users. Has many posts."
  object :headline do
    field :id, :integer
    field :title, :string
    field :network, :string
    field :url, :string
    field :description, :string
    field :published_at, :string
    field :posts, list_of(:post), resolve: assoc(:posts)
  end

  @desc "Posts belong to Headliness and Users. Has many Proofs and References"
  object :post do
    field :id, :integer
    field :body, :string
    field :headline_id, :integer
    field :user_id, :integer
    field :referencess, list_of(:reference), resolve: assoc(:references)
    field :up_votes, list_of(:post_vote_up), resolve: assoc(:post_vote_up)
    field :down_votes, list_of(:post_vote_down), resolve: assoc(:post_vote_down)
  end

  @desc "References - has many proofs"
  object :reference do
    field :id, :integer
    field :doi, :string
    field :posts, list_of(:post), resolve: assoc(:posts)
  end





#######INPUT OBJECTS########

  @desc "An input object for :post"
  input_object :input_post do
    field :body, :string
    field :references, list_of(:input_reference)
  end

  @desc "An input object for :reference"
  input_object :input_reference do
    field :doi, non_null(:string)
  end

end