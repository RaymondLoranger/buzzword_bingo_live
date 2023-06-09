defmodule Buzzword.Bingo.LiveWeb.GameTerminate do
  use Buzzword.Bingo.LiveWeb, [:html, :aliases]

  require Logger

  @spec terminate(:normal | :shutdown, Socket.t()) :: term
  def terminate(reason, socket) do
    # Player may not have logged in or game may not have started yet...
    player = socket.assigns[:player]
    game_name = socket.assigns[:game_name] || "?"
    topic = socket.assigns[:topic]
    player_count = GamePresence.list(topic) |> length()

    if player do
      Logger.warn("Player '#{player.name}' quitting game '#{game_name}'.")
    else
      Logger.warn("Unknown player quitting game '#{game_name}'.")
    end

    Logger.warn("Reason: #{inspect(reason)}")

    if player_count == 1 do
      Logger.warn("Ending game: #{game_name}")
      Engine.end_game(game_name)
    end
  end
end
