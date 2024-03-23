defmodule Buzzword.Bingo.LiveWeb.GameLive do
  use Buzzword.Bingo.LiveWeb, [:live_view, :aliases]

  @impl LV
  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(player: nil)
     |> stream(:messages, [])
     |> stream_configure(:players, dom_id: &hash(:players, &1.name))
     |> stream_configure(:squares, dom_id: &hash(:squares, &1.phrase))}
  end

  # render assigns: game_name, game_size, game_url, next_to, player, streams,
  #                 topic, winner

  @impl LV
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

  @impl LV
  defdelegate handle_params(params, uri, socket), to: GameParams
  @impl LV
  defdelegate handle_info(msg, socket), to: GameInfo
  @impl LV
  defdelegate terminate(reason, socket), to: GameTerminate

  ## Private functions

  @spec hash(atom, String.t()) :: String.t()
  defp hash(name, uniq) do
    "#{name}-#{uniq |> String.to_charlist() |> Enum.sum()}"
  end
end
