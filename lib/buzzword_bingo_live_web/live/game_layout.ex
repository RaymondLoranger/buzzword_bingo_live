defmodule Buzzword.Bingo.LiveWeb.GameLayout do
  use Buzzword.Bingo.LiveWeb, [:live_component, :aliases]

  import GameComponents

  # Color #FBD433 is bright sun...
  @no_winner Player.new("X", "#FBD433")

  # initial assigns:
  # passed assigns : game_name, game_size, game_url, player, streams, topic,
  #                  winner
  # render assigns : game_name, game_size, game_url, player, streams, topic,
  #                  winner

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article>
      <.focus_wrap id="game-layout-wrap">
        <.game_layout>
          <:game_url>
            <.game_url_field id="game-url" value={@game_url} />
            <.copy_url_button target={@myself} click="copy-url" />
          </:game_url>
          <.board game_size={@game_size} update="stream">
            <.square
              :for={{dom_id, square} <- @streams.squares}
              id={dom_id}
              square={square}
              target={@myself}
              click="mark"
              phrase={square.phrase}
              keyup="mark"
              key="Enter"
            />
          </.board>

          <.game_over? winner={@winner} />

          <.chatroom :if={@game_size > 0}>
            <.players_panel streams={@streams} player={@player} />
            <.messages_panel streams={@streams} />
            <.live_component
              module={MessageForm}
              id="message-form"
              topic={@topic}
              player={@player}
            />
          </.chatroom>
        </.game_layout>
      </.focus_wrap>
    </article>
    """
  end

  @spec handle_event(event :: binary, LiveView.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("copy-url", _payload, socket) do
    Clipboard.copy(socket.assigns.game_url)
    {:noreply, push_event(socket, "select-text", %{id: "game-url"})}
  end

  def handle_event("mark", %{"phrase" => phrase}, socket) do
    %{game_name: game_name, topic: topic, player: player} = socket.assigns

    case Engine.mark_square(game_name, phrase, player) do
      %Summary{squares: squares, scores: scores, winner: winner} ->
        total_squares = length(squares) |> Integer.pow(2)
        marked_squares = Enum.sum(for {_name, %{marked: n}} <- scores, do: n)
        winner = winner || if marked_squares == total_squares, do: @no_winner
        if winner, do: Endpoint.broadcast(topic, "winner", winner)
        GamePresence.update(topic, player.name, scores)
        square = List.flatten(squares) |> Enum.find(&(&1.phrase == phrase))
        Endpoint.broadcast(topic, "square", square)

      {:error, _noproc} ->
        # Game server may have timed out...
        # Notify this player and the other ones...
        Endpoint.broadcast(topic, "game_not_found", game_name)
    end

    {:noreply, socket}
  end
end
