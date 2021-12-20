defmodule V2OrderRequest.Orders do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> validate_required([:game_name, :item, :amount, :assigned_to, :requested_by, :fulfilled, :created_on, :completed_on, :note])
  end
end
