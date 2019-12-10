defmodule LiveViewDemoWeb.DemoLive do
  use Phoenix.LiveView

  alias Phoenix.View
  alias LiveViewDemo.Backend
  alias LiveViewDemoWeb.DemoView

  def render(assigns) do
    View.render(DemoView, "live_view.html", assigns)
  end

  def mount(%{id: id}, socket) do
    route = Backend.route(id)
    if connected?(socket), do: :timer.send_after(2000, self(), {:refresh, id})
    {:ok, assign(socket, route: route)}
  end

  def handle_info({:refresh, id}, socket) do
    route = Backend.route(id)
    :timer.send_after(2000, self(), {:refresh, id})
    {:noreply, assign(socket, route: route)}
  end
end
