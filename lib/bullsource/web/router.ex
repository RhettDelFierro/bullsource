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

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, handler: Bullsource.Web.AuthController
  end

  # Other scopes may use custom stacks.
   scope "/api", Bullsource.Web do
     pipe_through :api
     post "/sessions", SessionController, :create #logon
     #delete "/sessions", SessionController, :delete

     resources "/topics", TopicController, only: [:index]

     resources "/users", UserController #for registering and soon to be updating.

     #another scope for the protected routes?
   end

   scope "/api", Bullsource.Web do
      pipe_through [:api, :require_login]

      resources "/topics", TopicController, except: [:index]
    end
end
