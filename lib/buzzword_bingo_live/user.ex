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
      if color in Enum.map(players, & &1.meta.color),
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
    phx_1 = if color == "#a4deff", do: "phx-1", else: ""
    phx_2 = if color == "#f9cedf", do: "phx-2", else: ""
    phx_3 = if color == "#d3c5f1", do: "phx-3", else: ""
    phx_4 = if color == "#acc9f5", do: "phx-4", else: ""
    phx_5 = if color == "#aeeace", do: "phx-5", else: ""
    phx_6 = if color == "#96d7b9", do: "phx-6", else: ""
    phx_7 = if color == "#fce8bd", do: "phx-7", else: ""
    phx_8 = if color == "#fcd8ac", do: "phx-8", else: ""

    """
    <span>
      color
      <span
        #{phx_1}
        #{phx_2}
        #{phx_3}
        #{phx_4}
        #{phx_5}
        #{phx_6}
        #{phx_7}
        #{phx_8}
        class="font-bold phx-1:bg-[#a4deff] phx-2:bg-[#f9cedf] phx-3:bg-[#d3c5f1] phx-4:bg-[#acc9f5] phx-5:bg-[#aeeace] phx-6:bg-[#96d7b9] phx-7:bg-[#fce8bd] phx-8:bg-[#fcd8ac]"
      >
        #{color}
      </span>
      already taken
    </span>
    """
  end
end
