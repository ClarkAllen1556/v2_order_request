defmodule V2OrderRequest.Orders do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias V2OrderRequest.Repo
  alias V2OrderRequest.Orders

  schema "orders" do
    field :amount, :integer
    field :assigned_to, :string
    field :completed_on, :naive_datetime
    field :created_on, :naive_datetime
    field :fulfilled, :boolean, default: false
    field :game_name, :string
    field :item, :string
    field :note, :string
    field :requested_by, :string

    timestamps()
  end

  @doc false
  def changeset(orders, attrs) do
    orders
    |> cast(attrs, [:game_name, :item, :amount, :assigned_to, :requested_by, :fulfilled, :created_on, :completed_on, :note])
    |> validate_required([:game_name, :item, :amount, :requested_by])
  end

  def list_orders do
    Repo.all(Orders)
  end

  def list_orders (game_name) do
    Repo.all(from o in Orders, where: ilike(o.game_name, ^game_name),
      select: %{
        id: o.id,
        game_name: o.game_name,
        item: o.item,
        amount: o.amount,
        assigned_to: o.assigned_to,
        requested_by: o.requested_by
      }
    )
  end

  def delete_order (order_id) do
    order = Repo.get!(Orders, order_id)
    Repo.delete(order)
  end

  def create_order (attrs \\ %{}) do
    %Orders{}
    |> Orders.changeset(attrs)
    |> Repo.insert()
  end
end
