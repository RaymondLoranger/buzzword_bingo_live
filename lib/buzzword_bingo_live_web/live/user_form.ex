defmodule Buzzword.Bingo.LiveWeb.UserForm do
  use Buzzword.Bingo.LiveWeb, [:live_component, :aliases]
  use PersistConfig

  import GameComponents

  @colors get_env(:player_colors)
  @empty_form User.changeset() |> to_form()

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok,
     assign(socket,
       color: hd(@colors),
       colors: @colors,
       form: @empty_form
     )}
  end

  # initial assigns: color, colors, form
  # passed assigns : id, next_to, topic
  # render assigns : color, colors, form, id, next_to, topic

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article id={"#{@id}-component"}>
      <.focus_wrap id={"#{@id}-focus-wrap"}>
        <.user_form
          id={@id}
          for={@form}
          target={@myself}
          change="validate"
          submit="play"
        >
          <.user_fields id={"#{@id}-fields"}>
            <.name_field field={@form[:name]} color={@color} />
            <.color_field
              field={@form[:color]}
              colors={@colors}
              color={@color}
              click="update-color"
              target={@myself}
            />
          </.user_fields>
          <.submit_button text="Play Bingo!" />
        </.user_form>
      </.focus_wrap>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("update-color", %{"value" => color}, socket) do
    {:noreply, assign(socket, color: color)}
  end

  def handle_event("validate", %{"user" => user}, socket) do
    players = GamePresence.list(socket.assigns.topic)
    changeset = User.validate(user, players)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("play", %{"user" => user}, socket) do
    players = GamePresence.list(socket.assigns.topic)

    case User.create(user, players) do
      {:ok, user} ->
        player = Player.new(user.name, user.color)
        send(self(), {:player_created, player, socket.assigns.next_to})
        # Parent's handle_info/2 will call push_patch/2...
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
