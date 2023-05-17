defmodule Buzzword.Bingo.LiveWeb.Router do
  use Buzzword.Bingo.LiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Buzzword.Bingo.LiveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Buzzword.Bingo.LiveWeb do
    pipe_through :browser

    get "/home", PageController, :home

    live "/", GameLive, :login
    live "/login", GameLive, :login
    live "/login/:to", GameLive, :login
    live "/games/new", GameLive, :new
    live "/games/:id", GameLive, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", Buzzword.Bingo.LiveWeb do
  #   pipe_through :api
  # end

  import Phoenix.LiveDashboard.Router

  scope "/dev" do
    pipe_through :browser

    live_dashboard "/dashboard", metrics: Buzzword.Bingo.LiveWeb.Telemetry
  end
end
