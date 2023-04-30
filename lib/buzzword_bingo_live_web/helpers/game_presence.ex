defmodule Buzzword.Bingo.LiveWeb.GamePresence do
  use Buzzword.Bingo.LiveWeb, [:html, :aliases]

  @spec list(Phoenix.Presence.topic()) :: %{Player.name() => meta :: map}
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

  @spec players(Phoenix.Presence.presences()) :: %{Player.name() => meta :: map}
  defp players(presences) do
    for {name, %{metas: [meta | _]}} <- presences, into: %{} do
      {name, meta}
      # => {"Ray", %{color: "#a4deff", marked: 0, phx_ref: "...", score: 0}}
    end

    # => %{
    #      "Joe" => %{color: "#f9cedf", marked: 0, phx_ref: "...", score: 0},
    #      "Ray" => %{color: "#a4deff", marked: 0, phx_ref: "...", score: 0}
    #    }
  end

  @spec remove_players(Socket.t(), Phoenix.Presence.presences()) :: Socket.t()
  defp remove_players(socket, leaves) do
    players = Map.drop(socket.assigns.players, Map.keys(leaves))
    assign(socket, :players, players)
  end

  @spec add_players(Socket.t(), Phoenix.Presence.presences()) :: Socket.t()
  defp add_players(socket, joins) do
    players = Map.merge(socket.assigns.players, players(joins))
    assign(socket, :players, players)
  end
end
