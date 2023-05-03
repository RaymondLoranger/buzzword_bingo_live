defmodule Buzzword.Bingo.LiveWeb.MessageForm do
  use Buzzword.Bingo.LiveWeb, [:live_component, :aliases]

  import GameComponents

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, text: "")}
  end

  # passed assigns : player, topic
  # initial assigns: text
  # render assigns : player, text, topic

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <div>
      <.message_form submit="send-msg" change="text-change" target={@myself}>
        <.message_input_field name="text" value={@text} />
        <.message_submit_button disabled={@text == ""} />
      </.message_form>
    </div>
    """
  end

  @spec handle_event(event :: binary, LiveView.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("text-change", %{"text" => text}, socket) do
    {:noreply, assign(socket, text: text)}
  end

  def handle_event("send-msg", %{"text" => text}, socket) do
    player = socket.assigns.player
    message = %{text: text, sender: player}
    Endpoint.broadcast(socket.assigns.topic, "new_message", message)
    {:noreply, assign(socket, text: "")}
  end
end
