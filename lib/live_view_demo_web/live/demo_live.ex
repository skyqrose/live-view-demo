defmodule LiveViewDemoWeb.DemoLive do
  use Phoenix.LiveView

  alias Phoenix.View
  alias LiveViewDemoWeb.DemoView

  def render(assigns) do
    View.render(DemoView, "live_view.html", assigns)
  end

  def mount(%{id: _id}, socket) do
    {:ok, socket}
  end
end
