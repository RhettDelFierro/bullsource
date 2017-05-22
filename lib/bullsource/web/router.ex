defmodule Bullsource.Web.Router do
  use Bullsource.Web, :router

  pipeline :graphql do
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Poison
    plug Bullsource.Web.Context # this will be for auth.
  end

  forward "/graphql", Absinthe.Plug.GraphiQL, schema: Bullsource.GraphQL.Schema
end
