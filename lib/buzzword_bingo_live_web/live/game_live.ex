defmodule Buzzword.Bingo.LiveWeb.GameLive do
  use Buzzword.Bingo.LiveWeb, [:live_view, :aliases]

  @spec mount(LiveView.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, player: nil, players: %{}),
     temporary_assigns: [squares: [], messages: []]}
  end

  # render assigns: game_name, game_size, messages, player, players, return_to,
  #                 squares, topic, game_url, winner

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <%= case @live_action do %>
      <% :login -> %>
        <.live_component
          module={UserForm}
          id="user-form"
          topic={@topic}
          return_to={@return_to}
        />
      <% :new -> %>
        <.live_component module={GameSizeForm} id="game-size-form" />
      <% :show -> %>
        <.live_component
          module={GameField}
          id="game-field"
          game_url={@game_url}
          game_size={@game_size}
          game_name={@game_name}
          topic={@topic}
          squares={@squares}
          player={@player}
          players={@players}
          messages={@messages}
          winner={@winner}
        />
    <% end %>
    """
  end

  defdelegate handle_params(params, uri, socket), to: GameParams
  defdelegate handle_info(msg, socket), to: GameInfo
  defdelegate terminate(reason, socket), to: GameTerminate
end
