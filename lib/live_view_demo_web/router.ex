defmodule LiveViewDemoWeb.Router do
  use LiveViewDemoWeb, :router

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

  scope "/", LiveViewDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/demo/react/:id", DemoController, :react
    get "/demo/live_view/:id", DemoController, :live_view
    get "/demo/elm/:id", DemoController, :elm
  end

  scope "/", LiveViewDemoWeb do
    pipe_through :api

    get "/demo/react_api/:id", DemoController, :react_api
  end
end
