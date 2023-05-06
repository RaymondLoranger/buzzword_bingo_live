defmodule Buzzword.Bingo.Live.User do
  use Ecto.Schema
  use PersistConfig

  import Ecto.Changeset

  alias __MODULE__
  alias Buzzword.Bingo.LiveWeb.GamePresence

  @colors get_env(:player_colors)
  @max_players get_env(:max_players)
  @primary_key false

  embedded_schema do
    field :name, :string
    field :color, :string
  end

  @spec changeset(map, [GamePresence.player()]) :: Ecto.Changeset.t()
  def changeset(attrs \\ %{}, players \\ []) do
    %User{}
    |> cast(attrs, [:name, :color])
    |> validate_length(:name, min: 2, max: 9, message: out_of_range(2, 9))
    |> validate_change(:name, fn :name, name ->
      if name in Enum.map(players, & &1.name),
        do: [name: name_taken_msg(name)],
        else: []
    end)
    |> validate_change(:name, fn :name, _name ->
      if length(players) >= @max_players,
        do: [name: "players limit (#{@max_players}) already reached"],
        else: []
    end)
    |> validate_inclusion(:color, @colors, message: "invalid color")
    |> validate_change(:color, fn :color, color ->
      if color in Enum.map(players, & &1.color),
        do: [color: color_taken_msg(color)],
        else: []
    end)
  end

  @spec validate(map, [GamePresence.player()]) :: Ecto.Changeset.t()
  def validate(attrs, players) do
    changeset(attrs, players)
    # Required to see validation errors...
    |> struct(action: :validate)
  end

  @spec create(map, [GamePresence.player()]) ::
          {:ok, %User{}} | {:error, Ecto.Changeset.t()}
  def create(attrs, players) do
    changeset(attrs, players) |> apply_action(:create)
  end

  ## Private functions

  defp out_of_range(min, max) do
    """
    <span>
      must be
      <span class="font-bold">#{min}</span>
      to
      <span class="font-bold">#{max}</span>
      chars
    </span>
    """
  end

  defp name_taken_msg(name) do
    """
    <span>
      name
      <span class="font-bold">#{name}</span>
      already taken
    </span>
    """
  end

  defp color_taken_msg(color) do
    """
    <span>
      color
      <span class="font-bold bg-[#{color}]">
        #{color}
      </span>
      already taken
    </span>
    """
  end
end
