defmodule Buzzword.Bingo.LiveWeb.GamePresence do
  use Buzzword.Bingo.LiveWeb, [:html, :imports, :aliases]

  @type player :: %{name: Player.name(), meta: map}

  @spec list(Phoenix.Presence.topic()) :: [player]
  def list(topic), do: Presence.list(topic) |> players()

  @spec assign_players(Socket.t(), %{
          joins: Phoenix.Presence.presences(),
          leaves: Phoenix.Presence.presences()
        }) :: Socket.t()
  def assign_players(socket, diff) do
    # A player both leaving and joining would move to the end of the list.
    leaves = Map.drop(diff.leaves, Map.keys(diff.joins))
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
      %{name: name, meta: meta}
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
