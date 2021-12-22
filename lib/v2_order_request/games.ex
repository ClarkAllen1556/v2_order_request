defmodule V2OrderRequest.Games do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias V2OrderRequest.{Repo, Games}

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
    |> validate_required([:game_name])
  end

  def create_game (attrs \\ %{}) do
    %Games{}
    |> Games.changeset(attrs)
    |> Repo.insert()
  end

  def list_games do
    Repo.all(Games)
  end

  def game_exists (game_name) do
    Repo.exists?(from g in Games, where: g.game_name == ^game_name)
  end
end
