defmodule Buzzword.Bingo.LiveWeb.GamePresence do
  use Buzzword.Bingo.LiveWeb, [:html, :imports, :aliases]

  @type player :: %{name: String.t(), meta: map}

  @spec list(Phoenix.Presence.topic()) :: [player]
  def list(topic), do: Presence.list(topic) |> players()

  @spec assign_players(Socket.t(), %{
          joins: Phoenix.Presence.presences(),
          leaves: Phoenix.Presence.presences()
        }) :: Socket.t()
  def assign_players(socket, diff) do
    socket |> remove_players(diff.leaves) |> add_players(diff.joins)
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
    Enum.reduce(players(leaves), socket, fn player, socket ->
      stream_delete(socket, :players, player)
    end)
  end

  @spec add_players(Socket.t(), Phoenix.Presence.presences()) :: Socket.t()
  defp add_players(socket, joins) do
    Enum.reduce(players(joins), socket, fn player, socket ->
      stream_insert(socket, :players, player)
    end)
  end
end
