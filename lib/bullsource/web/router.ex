defmodule Bullsource.Web.Router do
  use Bullsource.Web, :router

  forward "/graphql", Absinthe.Plug.GraphiQL, schema: Bullsource.GraphQL.Schema
end
