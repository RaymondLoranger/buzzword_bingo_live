defmodule Buzzword.Bingo.LiveWeb.GameField do
  use Buzzword.Bingo.LiveWeb, [:live_component, :aliases]

  import GameComponents

  @no_winner Player.new("X", "#FBD433")

  # passed assigns : game_name, game_size, messages, player, players, squares,
  #                  topic, game_url, winner
  # initial assigns:
  # render assigns : game_name, game_size, messages, player, players, squares,
  #                  topic, game_url, winner

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article>
      <.game_field>
        <:game_url>
          <.game_url_field value={@game_url} />
          <.copy_url_button target={@myself} click="copy-url-click" />
        </:game_url>
        <.board game_size={@game_size} update="stream">
          <.square
            :for={{dom_id, square} <- @streams.squares}
            id={dom_id}
            square={square}
            target={@myself}
            click="square-click"
            phrase={square.phrase}
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
      </.game_field>
    </article>
    """
  end

  @spec handle_event(event :: binary, LiveView.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("copy-url-click", _payload, socket) do
    Clipboard.copy(socket.assigns.game_url)
    {:noreply, push_event(socket, "select-text", %{id: "game-url"})}
  end

  def handle_event("square-click", %{"phrase" => phrase}, socket) do
    %{game_name: game_name, topic: topic, player: player} = socket.assigns

    case Engine.mark_square(game_name, phrase, player) do
      %Summary{squares: squares, scores: scores, winner: winner} ->
        total_squares = length(squares) |> Integer.pow(2)
        marked_squares = Enum.sum(for {_name, %{marked: n}} <- scores, do: n)
        winner = winner || if marked_squares == total_squares, do: @no_winner
        if winner, do: Endpoint.broadcast(topic, "winner_alert", winner)
        GamePresence.update(topic, player.name, scores)
        square = List.flatten(squares) |> Enum.find(&(&1.phrase == phrase))
        Endpoint.broadcast(topic, "new_square", square)

      {:error, _noproc} ->
        # Game server may have timed out...
        # Notify this player and the other ones...
        Endpoint.broadcast(topic, "game_not_found", game_name)
    end

    {:noreply, socket}
  end
end
