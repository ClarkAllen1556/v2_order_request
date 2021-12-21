defmodule V2OrderRequest.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:game) do
      add :game_name, :string
      add :note, :string
      add :created_on, :naive_datetime

      timestamps()
    end

  end
end
