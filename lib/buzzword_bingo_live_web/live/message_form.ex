defmodule Buzzword.Bingo.LiveWeb.MessageForm do
  use Buzzword.Bingo.LiveWeb, [:live_component, :aliases]

  import GameComponents

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, text: "")}
  end

  # initial assigns: text
  # passed assigns : id, player, topic
  # render assigns : text, id, player, topic

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article id={"#{@id}-component"}>
      <.message_form
        id={@id}
        submit="send-msg"
        change="update-text"
        target={@myself}
      >
        <.message_input_field name="text" value={@text} />
        <.message_submit_button disabled={@text == ""} />
      </.message_form>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("update-text", %{"text" => text}, socket) do
    {:noreply, assign(socket, text: text)}
  end

  def handle_event("send-msg", %{"text" => text}, socket) do
    player = socket.assigns.player
    message = %{id: UUID.generate(), text: text, sender: player}
    Endpoint.broadcast(socket.assigns.topic, "message", message)
    {:noreply, assign(socket, text: "")}
  end
end
