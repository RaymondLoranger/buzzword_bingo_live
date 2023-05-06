defmodule Buzzword.Bingo.LiveWeb.GamePresence do
  use Buzzword.Bingo.LiveWeb, [:html, :imports, :aliases]

  @type player :: %{
          name: Player.name(),
          color: Player.color(),
          score: Game.points_sum(),
          marked: Game.marked_count()
        }

  @spec list(Phoenix.Presence.topic()) :: [player]
  def list(topic), do: Presence.list(topic) |> players()

  @spec assign_players(Socket.t(), %{
          joins: Phoenix.Presence.presences(),
          leaves: Phoenix.Presence.presences()
        }) :: Socket.t()
  def assign_players(socket, diff) do
    IO.inspect(diff.leaves, label: "====== diff.leaves ======")
    IO.inspect(diff.joins, label: "====== diff.joins ======")
    # Avoid leaving and joining so players remain in the same location.
    leaves = Map.drop(diff.leaves, Map.keys(diff.joins))
    IO.inspect(leaves, label: "====== leaves ======")
    socket |> remove_players(leaves) |> add_players(diff.joins)
  end

  @spec update(Phoenix.Presence.topic(), Player.name(), Summary.scores()) ::
          {:ok, ref :: binary} | {:error, reason :: term}
  def update(topic, name, scores) do
    %{metas: [meta | _]} = Presence.get_by_key(topic, name)
    Presence.update(self(), topic, name, Map.merge(meta, scores[name]))
  end

  ## Private functions

  @spec players(Phoenix.Presence.presences()) :: [player]
  defp players(presences) do
    for {name, %{metas: [meta | _]}} <- presences do
      %{name: name, color: meta.color, score: meta.score, marked: meta.marked}
    end
  end

  @spec remove_players(Socket.t(), Phoenix.Presence.presences()) :: Socket.t()
  defp remove_players(socket, leaves) do
    leaves |> players |> Enum.reduce(socket, &stream_delete(&2, :players, &1))
  end

  @spec add_players(Socket.t(), Phoenix.Presence.presences()) :: Socket.t()
  defp add_players(socket, joins) do
    joins |> players |> Enum.reduce(socket, &stream_insert(&2, :players, &1))
  end
end
