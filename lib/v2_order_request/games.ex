defmodule V2OrderRequest.Games do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game" do
    field :created_on, :naive_datetime
    field :game_name, :string
    field :note, :string

    timestamps()
  end

  @doc false
  def changeset(games, attrs) do
    games
    |> cast(attrs, [:game_name, :note, :created_on])
    |> validate_required([:game_name, :note, :created_on])
  end
end
