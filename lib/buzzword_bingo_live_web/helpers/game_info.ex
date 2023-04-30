defmodule Buzzword.Bingo.LiveWeb.GameInfo do
  use Buzzword.Bingo.LiveWeb, [:html, :imports, :aliases]

  require Logger

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info(%Broadcast{event: "new_square", payload: square}, socket) do
    {:noreply, update(socket, :squares, &[square | &1])}
  end

  def handle_info(%Broadcast{event: "new_message", payload: message}, socket) do
    {:noreply, update(socket, :messages, &[message | &1])}
  end

  def handle_info(%Broadcast{event: "winner_alert", payload: winner}, socket) do
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

  def handle_info({:player_created, player, return_to}, socket) do
    socket = assign(socket, :player, player)
    {:noreply, push_patch(socket, to: return_to)}
  end

  def handle_info(msg, socket) when is_binary(msg) or is_list(msg) do
    {:noreply, put_flash(socket, :info, raw(msg))}
  end

  def handle_info(msg, socket) do
    Logger.warn("""
    ::: Unknown message :::
    #{inspect(msg)}
    """)

    {:noreply, socket}
  end

  ## Private functions

  @spec game_not_found(Game.name()) :: HTML.safe()
  defp game_not_found(game_name) do
    raw("""
    Game
    <span class="font-semibold">
      #{game_name}
    </span>
    not found!
    """)
  end

  @spec game_already_started(Game.name()) :: HTML.safe()
  defp game_already_started(game_name) do
    raw("""
    Game
    <span class="font-semibold">
      #{game_name}
    </span>
    already started!!
    """)
  end

  @spec game_not_started(Game.name(), term) :: HTML.safe()
  defp game_not_started(game_name, reason) do
    raw("""
    Unable to start game
    <span class="font-semibold">
      #{game_name}
    </span>
    — reason:
    <span class="font-semibold">
      #{inspect(reason)}
    </span>
    """)
  end
end
