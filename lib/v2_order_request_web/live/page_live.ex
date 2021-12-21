defmodule V2OrderRequestWeb.PageLive do
  use V2OrderRequestWeb, :live_view
  alias V2OrderRequest.Games

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    Logger.info(mounted: "root page")

    {:ok,
      assign(socket,
        games: fetch()
      )
    }
  end

  @impl true
  def handle_event("redirect-game", %{"game_name" => game_name}, socket) do
    Logger.info(redirect_game: game_name)

    slug = "/" <> game_name

    {:noreply, push_redirect(socket, to: slug)}
  end

  defp fetch do
    Logger.info(action: "fetching games")

    Games.list_games()
  end
end
