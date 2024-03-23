defmodule Buzzword.Bingo.LiveWeb.GameInfo do
  use Buzzword.Bingo.LiveWeb, [:live_view, :html, :imports, :aliases]

  require Logger

  @impl LV
  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info(%Broadcast{event: "square", payload: square}, socket) do
    {:noreply, stream_insert(socket, :squares, square)}
  end

  def handle_info(%Broadcast{event: "message", payload: message}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end

  def handle_info(%Broadcast{event: "winner", payload: winner}, socket) do
    {:noreply, assign(socket, :winner, winner)}
  end

  def handle_info(%Broadcast{event: "presence_diff", payload: diff}, socket) do
    {:noreply, GamePresence.assign_players(socket, diff)}
  end

  def handle_info(%Broadcast{event: "game_not_found", payload: name}, socket) do
    {:noreply, put_flash(socket, :error, game_not_found(name))}
  end

  def handle_info({:game_not_found, name}, socket) do
    {:noreply, put_flash(socket, :error, game_not_found(name))}
  end

  def handle_info({:game_already_started, name}, socket) do
    {:noreply, put_flash(socket, :error, game_already_started(name))}
  end

  def handle_info({:game_not_started, name, why}, socket) do
    {:noreply, put_flash(socket, :error, game_not_started(name, why))}
  end

  def handle_info({:player_created, player, next_to}, socket) do
    socket = assign(socket, :player, player)
    {:noreply, push_patch(socket, to: next_to)}
  end

  def handle_info(msg, socket) when is_binary(msg) or is_list(msg) do
    {:noreply, put_flash(socket, :info, msg)}
  end

  def handle_info(msg, socket) do
    Logger.warning("""
    ::: Unknown message :::
    #{inspect(msg)}
    """)

    {:noreply, socket}
  end

  ## Private functions

  @spec game_not_found(Game.name()) :: String.t()
  defp game_not_found(game_name) do
    """
    Game
    <span class="font-semibold">
      #{game_name}
    </span>
    not found!
    """
  end

  @spec game_already_started(Game.name()) :: String.t()
  defp game_already_started(game_name) do
    """
    Game
    <span class="font-semibold">
      #{game_name}
    </span>
    already started!!
    """
  end

  @spec game_not_started(Game.name(), term) :: String.t()
  defp game_not_started(game_name, reason) do
    """
    Unable to start game
    <span class="font-semibold">
      #{game_name}
    </span>
    — reason:
    <span class="font-semibold">
      #{inspect(reason)}
    </span>
    """
  end
end
