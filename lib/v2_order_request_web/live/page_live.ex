defmodule V2OrderRequestWeb.PageLive do
  use V2OrderRequestWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("redirect-game", %{"game_name" => game_name}, socket) do
    Logger.info(redirect_game: game_name)

    slug = "/" <> game_name

    {:noreply, push_redirect(socket, to: slug)}
  end
end
