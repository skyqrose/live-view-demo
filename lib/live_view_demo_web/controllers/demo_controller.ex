defmodule LiveViewDemoWeb.DemoController do
  use LiveViewDemoWeb, :controller

  alias LiveViewDemo.Backend

  def react(conn, %{"id" => id}) do
    render(conn, "react.html", %{route: Backend.route(id)})
  end

  def live_view(conn, %{"id" => id}) do
    live_render(conn, LiveViewDemoWeb.DemoLive, session: %{id: id})
  end
end
