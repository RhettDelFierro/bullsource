defmodule Bullsource.GraphQL.Types.AccountTypes do
  use Absinthe.Ecto, repo: Bullsource.Repo
  use Absinthe.Schema.Notation

  @desc "User - has many Posts, Threads and all Votes."
  object :user do
    field :id, :integer
    field :username, :string
    field :email, :string
  end

  @desc "A JWT Token"
  object :token do
    field :token, :string
  end

end