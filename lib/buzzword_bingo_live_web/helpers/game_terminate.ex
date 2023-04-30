defmodule Buzzword.Bingo.LiveWeb.GameTerminate do
  use Buzzword.Bingo.LiveWeb, [:html, :aliases]

  require Logger

  @spec terminate(:normal | :shutdown, Socket.t()) :: term
  def terminate(reason, socket) do
    player = socket.assigns[:player]
    game_name = socket.assigns[:game_name]
    players = socket.assigns[:players]

    if player do
      Logger.warn("Player '#{player.name}' quitting game '#{game_name}'.")
    else
      Logger.warn("Unknown player quitting game '#{game_name}'.")
    end

    Logger.warn("Reason: #{inspect(reason)}")

    if players && map_size(players) == 1 do
      Logger.warn("Ending game: #{game_name}")
      Engine.end_game(game_name)
    end
  end
end
