defmodule LiveViewDemoWeb.DemoController do
  use LiveViewDemoWeb, :controller

  def react(conn, %{"id" => id}) do
    render(conn, "react.html", %{id: id})
  end

  def live_view(conn, %{"id" => id}) do
    live_render(conn, LiveViewDemoWeb.DemoLive, session: %{id: id})
  end
end
