defmodule Buzzword.Bingo.LiveWeb.GameParams do
  use Buzzword.Bingo.LiveWeb, [:live_view, :html, :imports, :aliases]

  @impl LV
  @spec handle_params(LV.unsigned_params(), String.t(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  ## Private functions

  @spec apply_action(Socket.t(), action :: atom, LV.unsigned_params()) ::
          Socket.t()
  # /login or /login/:to or /login/:to?game_name=...
  defp apply_action(socket, :login, params) do
    # For the host player landing here:
    #   • path....... "/login"
    #   • topic...... "game:"
    #   • next_to.... "/games/new"

    # For the host player redirected here (`path` includes %2F rather than /):
    #   • path....... "/login/%2Fgames%2Fnew"
    #   • topic...... "game:"
    #   • next_to.... "/games/new"

    # For guest players redirected here (`path` includes %2F rather than /):
    #   • path....... "/login/%2Fgames%2Ficy-fog-123?game_name=icy-fog-123"
    #   • topic...... "game:icy-fog-123"
    #   • next_to.... "/games/icy-fog-123"

    topic = "game:#{params["game_name"]}"
    next_to = params["to"] || ~p"/games/new"
    assign(socket, page_title: "User login", topic: topic, next_to: next_to)
  end

  # /games/new
  defp apply_action(socket, :new, _params) when is_nil(socket.assigns.player) do
    # For the host player (only) landing here (`to` includes %2F rather than /):
    #   • path....... "/games/new"
    #   • next_to.... "/games/new"
    #   • to......... "/login/%2Fgames%2new"

    # So the host player is "redirected" to log in before starting a game.

    next_to = ~p"/games/new"
    push_patch(socket, to: ~p"/login/#{next_to}")
  end

  # /games/new
  defp apply_action(socket, :new, _params) do
    assign(socket, page_title: "Game size")
  end

  # /games/:id
  defp apply_action(socket, :show, %{"id" => game_name})
       when is_nil(socket.assigns.player) do
    # Guards do not raise exceptions, they just fail instead.

    # For guest players (only) landing here (`to` includes %2F rather than /):
    #   • path....... "/games/icy-fog-123"
    #   • next_to.... "/games/icy-fog-123"
    #   • to......... "/login/%2Fgames%2Ficy-fog-123?game_name=icy-fog-123"

    # So a guest player is "redirected" to log in before joining the game.

    next_to = ~p"/games/#{game_name}"
    to = ~p"/login/#{next_to}?game_name=#{game_name}"
    push_patch(socket, to: to)
  end

  # /games/:id
  defp apply_action(socket, :show, %{"id" => game_name}) do
    game_url = url(~p"/games/#{game_name}") |> Clipboard.copy()
    player = socket.assigns.player
    topic = "game:" <> game_name

    {game_size, squares} =
      case Engine.game_summary(game_name) do
        %Summary{squares: squares} ->
          Endpoint.subscribe(topic)
          meta = %{color: player.color, score: 0, marked: 0}
          Presence.track(self(), topic, player.name, meta)
          {length(squares), List.flatten(squares)}

        {:error, _noproc} ->
          # Game server may have timed out...
          # Notify this player...
          send(self(), {:game_not_found, game_name})
          # And the other ones...
          Endpoint.broadcast(topic, "game_not_found", game_name)
          {0, []}
      end

    socket
    |> stream(:squares, squares)
    |> stream(:players, GamePresence.list(topic))
    |> assign(
      page_title: "Game #{game_name}",
      topic: topic,
      game_name: game_name,
      game_size: game_size,
      game_url: game_url,
      winner: nil
    )
  end
end
