defmodule Bullsource.Web.Router do
  use Bullsource.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  # Other scopes may use custom stacks.
   scope "/api", Bullsource.Web do
     pipe_through :api
     post "/sessions", SessionController, :create
     #delete "/sessions", SessionController, :delete

     resources "/users", UserController
   end
end
