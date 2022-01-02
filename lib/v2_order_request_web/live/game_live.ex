defmodule V2OrderRequestWeb.GameLive do
  use V2OrderRequestWeb, :live_view
  alias V2OrderRequest.Orders
  alias V2OrderRequest.Games

  require Logger

  @impl true
  # footprint needs to have params called 'id' b/c that's what rount is named in router
  def mount(%{"id" => game_name}, _session, socket) do
    Logger.info(mounted: game_name)

    unless Games.game_exists(game_name) do
      Games.create_game(%{game_name: game_name})
    end

    topic = "game" <> game_name

    if connected?(socket) do
      V2OrderRequestWeb.Endpoint.subscribe(topic)
    end

    {:ok,
      assign(socket,
        game_name: game_name,
        creating_order: :false,
        topic: topic,
        orders: fetch(game_name),
        changeset: Orders.changeset(%Orders{}, %{})
      ) #, temporary_assigns: [orders: []]
    }
  end

  def display_order (order) do
    ~E"""
      <div class="label"> <%= order.item %> </div>
      <div class="label"> <%= order.amount %> </div>
      <div class="label"> <%= order.assigned_to %> </div>
      <div class="label"> <%= order.requested_by %> </div>
      <div> <%= checkbox(
          :order_fulfilled,
          "order_fulfilled",
          phx_click: "toggle_done",
          phx_value_order: order.id,
          value: order.fulfilled
        )
        %> </div>
      <div>
        <button phx-click="delete-order" phx-value-order="<%= order.id %>"> 🗑 </button>
      </div>
      """
  end

  @impl true
  def handle_info(%{event: "new-order", payload: order}, socket) do
    Logger.info(event: "new-order", order: order, orders: socket.assigns.orders)

    {:noreply, assign(socket, orders: fetch(socket.assigns.game_name))}
  end

  @impl true
  def handle_info(%{event: "refresh", payload: _order}, socket) do
    Logger.info(event: "refresh")

    {:noreply, assign(socket, orders: fetch(socket.assigns.game_name))}
  end

  @impl true
  def handle_event("create_new_order", %{"orders" => order}, socket) do
    Logger.info(event: "create_new_order", order: order)

    new_order = Map.put(order, "game_name", socket.assigns.game_name)
    Orders.create_order(new_order)


    V2OrderRequestWeb.Endpoint.broadcast(socket.assigns.topic, "new-order", new_order)

    {:noreply, assign(socket, creating_order: :false)}
  end

  @impl true
  def handle_event("toggle_done", %{"order" => order_id}, socket) do
    Logger.info(event: "toggle_done", game: socket.assigns.game_name, orders: order_id)

    order = Orders.get_order(order_id)
    Orders.update_order(order, %{fulfilled: !order.fulfilled})

    V2OrderRequestWeb.Endpoint.broadcast(socket.assigns.topic, "refresh", order)

    {:noreply, socket}
  end

  @impl true
  def handle_event("edit-order", _params, socket) do
    Logger.info(event: "edit-order", game: socket.assigns.game_name, orders: socket.assigns.orders)

    {:noreply, assign(socket, creating_order: :true)}
  end

  @impl true
  def handle_event("delete-order", %{"order" => order}, socket) do
    Logger.info(event: "delete-order", game: socket.assigns.game_name, order_id: order)

    Orders.delete_order(order)

    V2OrderRequestWeb.Endpoint.broadcast(socket.assigns.topic, "refresh", order)

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle-create-new-order", _params, socket) do
    Logger.info(event: "toggle-create-new-order", game: socket.assigns.game_name, orders: socket.assigns.orders)

    {:noreply, assign(socket, creating_order: :true)}
  end

  @impl true
  def handle_event("cancel", _params, socket) do
    Logger.info(event: "cancel", game: socket.assigns.game_name)

    {:noreply, assign(socket, creating_order: :false)}
  end

  defp fetch(game_name) do
    Logger.info(action: "fecting orders", game: game_name)

    Orders.list_orders(game_name)
  end
end
