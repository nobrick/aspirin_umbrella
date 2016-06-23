defmodule Aspirin.Router do
  use Aspirin.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Aspirin do
    pipe_through :browser # Use the default browser stack

    get "/", MonitorEventController, :index
    resources "/events", MonitorEventController, except: [:show]
    resources "/events/enable", MonitorEvent.EnabledStateController, only: [:create, :delete]
    resources "/diagrams", DiagramController, except: [:edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Aspirin do
  #   pipe_through :api
  # end
end
