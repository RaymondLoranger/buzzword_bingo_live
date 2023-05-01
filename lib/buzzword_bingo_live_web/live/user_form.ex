defmodule Buzzword.Bingo.LiveWeb.UserForm do
  use Buzzword.Bingo.LiveWeb, [:live_component, :aliases]
  use PersistConfig

  import GameComponents

  @colors get_env(:player_colors)
  @empty_form User.changeset()
              |> to_form()
              |> IO.inspect(label: "EMPTY USER FORM")

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok,
     assign(socket,
       color: hd(@colors),
       colors: @colors,
       form: @empty_form
     )}
  end

  # passed assigns : return_to, topic
  # initial assigns: changeset, color, colors
  # render assigns : changeset, color, colors, return_to, topic

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <div>
      <.user_form
        id="user-form"
        for={@form}
        target={@myself}
        change="validate"
        submit="play"
      >
        <.user_fields>
          <.name_field form={@form} color={@color} />
          <.color_field
            form={@form}
            colors={@colors}
            color={@color}
            click="color-click"
            target={@myself}
          />
        </.user_fields>
        <.submit_button text="Play Bingo!" />
      </.user_form>
    </div>
    """
  end

  @spec handle_event(event :: binary, LiveView.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("color-click", %{"value" => color}, socket) do
    IO.inspect(color, label: "*** color on color-click ***")
    {:noreply, assign(socket, color: color)}
  end

  def handle_event("validate", %{"user" => user}, socket) do
    IO.inspect(user, label: "*** user on validate ***")
    players = GamePresence.list(socket.assigns.topic)
    changeset = User.validate(user, players)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("play", %{"user" => user}, socket) do
    IO.inspect(user, label: "*** user on play ***")
    players = GamePresence.list(socket.assigns.topic)

    case User.create(user, players) do
      {:ok, user} ->
        player = Player.new(user.name, user.color)
        send(self(), {:player_created, player, socket.assigns.return_to})
        # Parent's handle_info/2 will call push_patch/2...
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
