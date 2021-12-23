defmodule V2OrderRequestWeb.PageLive do
  use V2OrderRequestWeb, :live_view
  alias V2OrderRequest.Games

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    Logger.info(mounted: "root page")

    topic = "games_list"

    if connected?(socket) do
      V2OrderRequestWeb.Endpoint.subscribe(topic)
    end

    {:ok,
      assign(socket,
        games: fetch(),
        creating_game: :false,
        topic: topic,
        changeset: Games.changeset(%Games{}, %{})
      )
    }
  end

  @impl true
  def handle_info(%{event: "new-game-created", payload: game_name}, socket) do
    Logger.info(event: "new-game-created", game: game_name)

    {:noreply, assign(socket, games: fetch())}
  end

  @impl true
  def handle_event("new-game", _params, socket) do
    Logger.info(event: "create-game")

    {:noreply, assign(socket, creating_game: :true)}
  end

  @impl true
  def handle_event("cancel", _params, socket) do
    Logger.info(event: "cancel")

    {:noreply, assign(socket, creating_game: :false)}
  end

  @impl true
  def handle_event("create_new_game", %{"games" => game}, socket) do
    Logger.info(event: "create_new_game", game: game)

    unless Games.game_exists(game["game_name"]) do
      Games.create_game(game)
    end

    V2OrderRequestWeb.Endpoint.broadcast(socket.assigns.topic, "new-game-created", game["game_name"])

    {:noreply, socket}
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
