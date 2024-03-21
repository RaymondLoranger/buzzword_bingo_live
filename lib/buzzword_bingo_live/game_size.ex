defmodule Buzzword.Bingo.Live.GameSize do
  use Ecto.Schema
  use PersistConfig

  import Ecto.Changeset

  alias __MODULE__

  @sizes get_env(:game_sizes)
  @min @sizes.first
  @max @sizes.last
  @primary_key false

  embedded_schema do
    field :value, :integer
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(attrs \\ %{}) do
    %GameSize{}
    |> cast(attrs, [:value])
    |> validate_inclusion(:value, @sizes, message: out_of_range(@min, @max))
  end

  @spec validate(map) :: Ecto.Changeset.t()
  def validate(attrs) do
    changeset(attrs)
    # Required to see validation errors...
    |> struct(action: :validate)
  end

  @spec create(map) :: {:ok, %GameSize{}} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    changeset(attrs) |> apply_action(:create)
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
    </span>
    """
  end
end
