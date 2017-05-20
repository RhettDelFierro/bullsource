defmodule Bullsource.Web.Router do
  use Bullsource.Web, :router

  forward "/graphql", Absinthe.Plug.GraphQL, schema: Bullsource.GraphQL.Schema
end
