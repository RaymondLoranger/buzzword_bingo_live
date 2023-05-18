defmodule Buzzword.Bingo.LiveWeb.GameLive do
  use Buzzword.Bingo.LiveWeb, [:live_view, :aliases]

  @spec mount(LiveView.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(player: nil) |> stream(:messages, [])}
  end

  # render assigns: game_name, game_size, game_url, next_to, player, streams,
  #                 topic, winner

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.live_component
      :if={@live_action == :login}
      module={UserForm}
      id="user-form"
      topic={@topic}
      next_to={@next_to}
    />

    <.live_component
      :if={@live_action == :new}
      module={GameSizeForm}
      id="game-size-form"
    />

    <.live_component
      :if={@live_action == :show}
      module={GameLayout}
      id="game-layout"
      game_url={@game_url}
      game_size={@game_size}
      game_name={@game_name}
      topic={@topic}
      player={@player}
      streams={@streams}
      winner={@winner}
    />
    """
  end

  defdelegate handle_params(params, uri, socket), to: GameParams
  defdelegate handle_info(msg, socket), to: GameInfo
  defdelegate terminate(reason, socket), to: GameTerminate
end
