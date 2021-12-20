defmodule V2OrderRequest.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :game_name, :string
      add :item, :string
      add :amount, :integer
      add :assigned_to, :string
      add :requested_by, :string
      add :fulfilled, :boolean, default: false, null: false

      timestamps()
    end

  end
end
