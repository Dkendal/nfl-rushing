defmodule NflRushingWeb.Router do
  use NflRushingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NflRushingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NflRushingWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/rushes", RushLive.Index, :index
    live "/rushes/new", RushLive.Index, :new
    live "/rushes/:id/edit", RushLive.Index, :edit

    live "/rushes/:id", RushLive.Show, :show
    live "/rushes/:id/show/edit", RushLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", NflRushingWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NflRushingWeb.Telemetry
    end
  end
end