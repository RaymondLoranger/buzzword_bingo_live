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

  @spec out_of_range(pos_integer, pos_integer) :: String.t()
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

  @spec name_taken_msg(String.t()) :: String.t()
  defp name_taken_msg(name) do
    """
    <span>
      name
      <span class="font-bold">#{name}</span>
      already taken
    </span>
    """
  end

  @spec color_taken_msg(String.t()) :: String.t()
  defp color_taken_msg(color) do
    phx_1 = if color == "#38caf6", do: "phx-1", else: ""
    phx_2 = if color == "#a4deff", do: "phx-2", else: ""
    phx_3 = if color == "#f9cedf", do: "phx-3", else: ""
    phx_4 = if color == "#d3c5f1", do: "phx-4", else: ""
    phx_5 = if color == "#acc9f5", do: "phx-5", else: ""
    phx_6 = if color == "#aeeace", do: "phx-6", else: ""
    phx_7 = if color == "#96d7b9", do: "phx-7", else: ""
    phx_8 = if color == "#fce8bd", do: "phx-8", else: ""
    phx_9 = if color == "#fcd8ac", do: "phx-9", else: ""

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
        #{phx_9}
        class="font-bold text-rose-800 phx-1:bg-[#38caf6] phx-2:bg-[#a4deff] phx-3:bg-[#f9cedf] phx-4:bg-[#d3c5f1] phx-5:bg-[#acc9f5] phx-6:bg-[#aeeace] phx-7:bg-[#96d7b9] phx-8:bg-[#fce8bd] phx-9:bg-[#fcd8ac]"
      >
        #{color}
      </span>
      already taken
    </span>
    """
  end
end
