defmodule Bullsource.GraphQL.Types.AccountTypes do
  use Absinthe.Ecto, repo: Bullsource.Repo
  use Absinthe.Schema.Notation

  @desc "User - has many Posts and all Votes."
  object :user do
    field :id, :integer
    field :username, :string
    field :email, :string
  end

  @desc "A JWT Token"
  object :token do
    field :token, :string
  end

  @desc "User who has logged in/registered with a token"
  object :signed_in_user do
    field :user, :user, resolve: assoc(:user)
    field :token, :string
  end
end