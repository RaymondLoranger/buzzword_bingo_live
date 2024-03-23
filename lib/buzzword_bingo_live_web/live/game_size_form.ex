defmodule Buzzword.Bingo.LiveWeb.GameSizeForm do
  use Buzzword.Bingo.LiveWeb, [:live_component, :aliases]

  import GameComponents

  @init_form GameSize.changeset(%{value: 5}) |> to_form()

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, form: @init_form)}
  end

  # initial assigns: form
  # passed assigns :
  # render assigns : form

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article>
      <.focus_wrap id="game-size-form-wrap">
        <.game_size_form
          id="game-size-form"
          for={@form}
          target={@myself}
          change="validate"
          submit="start"
        >
          <.game_size_field field={@form[:value]} />
          <.submit_button text="Start Game" />
        </.game_size_form>
      </.focus_wrap>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("validate", %{"game_size" => game_size}, socket) do
    changeset = GameSize.validate(game_size)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("start", %{"game_size" => game_size}, socket) do
    case GameSize.create(game_size) do
      {:ok, game_size} ->
        game_name = Engine.haiku_name()

        case Buzzword.Bingo.Engine.new_game(game_name, game_size.value) do
          {:ok, _game_pid} ->
            game_path = ~p"/games/#{game_name}"
            {:noreply, push_patch(socket, to: game_path)}

          {:error, {:already_started, _started_game_pid}} ->
            # Extremely unlikely to happen...
            send(self(), {:game_already_started, game_name})
            {:noreply, socket}

          {:error, reason} ->
            # Even more unlikely to happen...
            send(self(), {:game_not_started, game_name, reason})
            {:noreply, socket}
        end

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
