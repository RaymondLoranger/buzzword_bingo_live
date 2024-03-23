defmodule Buzzword.Bingo.LiveWeb.GameTerminate do
  use Buzzword.Bingo.LiveWeb, [:live_view, :html, :aliases]

  require Logger

  @impl LV
  @spec terminate(:normal | :shutdown, Socket.t()) :: term
  def terminate(reason, socket) do
    # Player may not have logged in or game may not have started yet...
    player = socket.assigns[:player]
    game_name = socket.assigns[:game_name] || "?"
    topic = socket.assigns[:topic]
    player_count = GamePresence.list(topic) |> length()

    if player do
      Logger.warning("Player '#{player.name}' quitting game '#{game_name}'.")
    else
      Logger.warning("Unknown player quitting game '#{game_name}'.")
    end

    Logger.warning("Reason: #{inspect(reason)}")

    if player_count == 1 do
      Logger.warning("Ending game: #{game_name}")
      Engine.end_game(game_name)
    end
  end
end
