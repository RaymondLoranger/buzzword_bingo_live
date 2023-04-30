defmodule Buzzword.Bingo.LiveWeb.GameComponents do
  use Buzzword.Bingo.LiveWeb, [:html, :imports, :aliases]

  @spec grid_size(Socket.assigns()) :: Rendered.t()
  def grid_size(assigns) do
    ~H"""
    <span class="leading-4 tracking-tighter float-right mx-2 mt-2">
      <%= @text %>
    </span>
    """
  end

  def grid_glyph(assigns) do
    ~H"""
    <div class={"grid grid-cols-#{@size} gap-#{glyph_gap(@size)}"}>
      <%= for _n <- 1..(@size * @size) do %>
        <div class="p-1 aspect-square bg-wedgewood" />
      <% end %>
    </div>
    """
  end

  def game_size_field(assigns) do
    ~H"""
    <div class="w-full flex flex-col items-center h-full">
      <div
        id="game-sizes"
        class="w-full md:w-5/6 flex justify-evenly items-start flex-wrap place-content-center gap-6"
      >
        <label>
          <input
            class="ml-12 mt-2 mb-4"
            type="radio"
            value={5}
            checked
            phx-mounted={JS.focus()}
          />
          <.grid_size text="5 x 5" />
          <.grid_glyph size={5} />
        </label>
        <label>
          <input class="ml-12 mt-2 mb-4" type="radio" value={4} />
          <.grid_size text="4 x 4" />
          <.grid_glyph size={4} />
        </label>
        <label>
          <input class="ml-12 mt-2 mb-4" type="radio" value={3} />
          <.grid_size text="3 x 3" />
          <.grid_glyph size={3} />
        </label>
      </div>
    </div>
    """
  end

  def submit_button(assigns) do
    ~H"""
    <.button class={[
      "my-4 p-1 bg-carrot-orange w-28 rounded-md",
      "text-white hover:opacity-70"
    ]}>
      <%= @text %>
    </.button>
    """
  end

  def game_size_form(assigns) do
    ~H"""
    <article id="game-size-form">
      <h4 class="text-xl text-center mb-6">
        Select the game size:
      </h4>
      <.form
        :let={f}
        for={@for}
        phx-change={@change}
        phx-submit={@submit}
        phx-target={@target}
        class="mx-14 md:w-3/4 md:mx-auto flex flex-col items-center gap-2"
      >
        <%= render_slot(@inner_block, f) %>
      </.form>
    </article>
    """
  end

  def user_fields(assigns) do
    ~H"""
    <div class="flex flex-wrap place-content-center gap-x-5 mt-2 mx-2">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def name_field(assigns) do
    ~H"""
    <div class="flex flex-col h-auto mt-4">
      <input
        id="user-name"
        type="text"
        placeholder="Name"
        phx-mounted={JS.focus()}
        phx-debounce="500"
        required
        class="border-[#{@color}] h-6 px-2 py-3 border-2 rounded-sm focus:border-transparent"
        error_class="pl-2"
      />
    </div>
    """
  end

  def color_field(assigns) do
    ~H"""
    <div class="flex flex-col h-auto mt-4">
      <ul id="user-colors" class="flex gap-1.5">
        <li :for={color <- @colors} class="relative">
          <label
            title={color}
            class={
              "bg-[#{color}] flex w-6 m-0.5 aspect-square cursor-pointer border border-gray-500 hover:border-transparent hover:ring-gray-600 hover:ring-1"
            }
          >
            <input
              class="sr-only peer"
              type="radio"
              value={color}
              phx-target={@target}
              phx-click={@click}
              checked={color == @color}
            />
            <span class="absolute hidden peer-checked:block top-0.5 left-2">
              ✓
            </span>
          </label>
        </li>
      </ul>
    </div>
    """
  end

  def user_form(assigns) do
    ~H"""
    <article id="user-form" class="mx-auto flex flex-col items-center">
      <h1 class="mt-8 mb-2 text-4xl text-cool-gray-900">Welcome!</h1>
      <h4 class="m-2 text-xl font-thin text-cool-gray-900 text-center">
        First up, we need your name and favorite color:
      </h4>
      <.form
        :let={f}
        for={@for}
        phx-change={@change}
        phx-submit={@submit}
        phx-target={@target}
        class="flex flex-col items-center gap-4"
      >
        <%= render_slot(@inner_block, f) %>
      </.form>
    </article>
    """
  end

  def message_form(assigns) do
    ~H"""
    <article id="message-form" class="mt-2">
      <form phx-submit={@submit} phx-target={@target} phx-change={@change}>
        <span class="field-button-pair">
          <%= render_slot(@inner_block) %>
        </span>
      </form>
    </article>
    """
  end

  def message_input_field(assigns) do
    ~H"""
    <input
      type="text"
      name={@name}
      value={@value}
      placeholder="Enter your message..."
      class="truncate"
    />
    """
  end

  def message_submit_button(assigns) do
    ~H"""
    <button title="Send message" type="submit" disabled={@disabled}>
      <.icon name="hero-solid-chat-alt-2" />
    </button>
    """
  end

  def chatroom(assigns) do
    ~H"""
    <div id="chatroom" class="flex flex-col gap-0 sm:w-[27%] w-full">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def players_panel(assigns) do
    ~H"""
    <div class="text-white bg-deluge p-2 rounded-t-md">
      Who's Playing
    </div>
    <ul
      id="players"
      class="border-x-2 border-b-2 border-deluge rounded-b-md mb-0 bg-white"
      phx-update="replace"
    >
      <%= for {name, player} <- @players do %>
        <li class="border-b border-gray-200 p-1 whitespace-nowrap last:border-b-0 tracking-tight flex justify-between items-baseline">
          <span id="player-signature">
            <span class={
              "bg-[#{player.color}] aspect-square px-2 mx-1.5 rounded-sm text-xs"
            } />
            <%= if name == @player.name do %>
              <span class="font-medium tracking-tighter font-mono">
                <%= name %>
              </span>
            <% else %>
              <span><%= name %></span>
            <% end %>
          </span>

          <span id="player-tally" class="tracking-tighter text-sm ml-1.5">
            <span><%= player.score %> points</span>
            <span class="inline sm:hidden md:inline">
              ( <%= player.marked %>
              <%= ngettext("square", "squares", player.marked) %> )
            </span>
          </span>
        </li>
      <% end %>
    </ul>
    """
  end

  def messages_panel(assigns) do
    ~H"""
    <div class="text-white bg-deluge p-2 rounded-t-md mt-2">
      What's Up?
    </div>
    <ul
      id="messages"
      phx-update="append"
      phx-hook="ScrollToEnd"
      class="flex-auto border-x-2 border-b-2 border-deluge rounded-b-md bg-white overflow-y-auto min-h-[35px]"
    >
      <%= for message <- @messages do %>
        <li
          id={message.id}
          class="border-b border-gray-200 p-1 tracking-tight"
        >
          <span class={"bg-[#{message.sender.color}] pl-1.5 pr-0.5 mr-1 rounded-sm"}>
            <%= message.sender.name %>
          </span>
          <span><%= message.text %></span>
        </li>
      <% end %>
    </ul>
    """
  end

  def square(assigns) do
    ~H"""
    <div
      class={
        "#{if @square.marked_by, do: "bg-[#{@square.marked_by.color}]"} bg-white shadow aspect-square grid gap-2 grid-rows-3 rounded-md text-cool-gray-600 border border-cool-gray-300 hover:scale-95 hover:border-cool-gray-400"
      }
      id={@square.phrase}
      phx-target={@target}
      phx-click={@click}
      phx-value-payload={@payload}
    >
      <%= if @square.marked_by do %>
        <span class="text-xs leading-3 self-start justify-self-start p-0.5 sm:p-1">
          <%= @square.marked_by.name %>
        </span>
      <% else %>
        <span>&nbsp;</span>
      <% end %>

      <span class={
        "#{word_break(@square.phrase)} text-xs leading-3 sm:text-sm sm:leading-3 md:text-base md:leading-4 tracking-tightest sm:tracking-tighter md:tracking-tight font-medium self-center justify-self-center text-center p-0.5 sm:p-1"
      }>
        <%= @square.phrase %>
      </span>

      <span class="text-xs leading-3 self-end justify-self-end p-0.5 sm:p-1">
        <%= @square.points %>
      </span>
    </div>
    """
  end

  def board(assigns) do
    ~H"""
    <div
      id="board"
      class={"grid grid-cols-#{@game_size} gap-2 sm:w-[70%] w-full"}
      phx-update={@update}
    >
      <%= for square <- @squares do %>
        <%= render_slot(@inner_block, square) %>
      <% end %>
    </div>
    """
  end

  def game_field(assigns) do
    ~H"""
    <article id="game-field">
      <section id="game-url-pair">
        <span class="field-button-pair mb-4">
          <%= render_slot(@game_url) %>
        </span>
      </section>
      <section
        id="playground"
        class="flex flex-col sm:flex-row justify-center gap-3 h-full mx-2"
      >
        <%= render_slot(@inner_block) %>
      </section>
    </article>
    """
  end

  def game_url_field(assigns) do
    ~H"""
    <input
      class="!w-2/3 md:!w-1/2"
      id="game-url"
      type="text"
      title={@value}
      value={@value}
      readonly
    />
    """
  end

  def copy_url_button(assigns) do
    ~H"""
    <button title="Copy game URL" phx-click={@click} phx-target={@target}>
      <.icon name="hero-solid-clipboard-copy" />
    </button>
    """
  end

  def game_over?(assigns) do
    ~H"""
    <%= if @winner do %>
      <div class="absolute left-0 w-full sm:top-1/2 sm:text-5xl text-center animate-ping top-1/3 text-4xl">
        <%= if @winner.name == "X" do %>
          <span>No winner!</span>
          <br /><br />
          <span>
            <.sad_face
              color={@winner.color}
              width="100px"
              height="100px"
              class="inline"
            />
          </span>
        <% else %>
          <span><%= @winner.name %> won!</span>
          <br /><br />
          <span>
            <.smiling_face_with_sunglasses
              color={@winner.color}
              width="100px"
              height="100px"
              class="inline"
            />
          </span>
        <% end %>
      </div>
    <% end %>
    """
  end

  def login_icon do
    raw("""
    <img src="/images/user-login.png" title="login" />
    """)
  end

  ## Private functions

  defp word_break(phrase) do
    # Empowerment -> 11 letters
    # Microservice -> 12 letters
    # Opportunities -> 13 letters
    # class="break-all break-words"
    words = String.split(phrase, [" ", "-"], trim: true)
    max_length = Enum.map(words, &String.length/1) |> Enum.max()

    if length(words) == 1 and max_length > 9 do
      "break-all"
    else
      "break-words"
    end
  end

  defp glyph_gap(3), do: "2"
  defp glyph_gap(4), do: "1.5"
  defp glyph_gap(5), do: "1"
  defp glyph_gap(6), do: "0.5"

  defp sad_face(assigns) do
    ~H"""
    <svg
      width={@width}
      height={@height}
      class={@class}
      version="1.1"
      id="Layer_1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      x="0px"
      y="0px"
      viewBox="0 0 122.88 122.88"
      style="enable-background:new 0 0 122.88 122.88"
      xml:space="preserve"
    >
      <style type="text/css">
        .st0{fill-rule:evenodd;clip-rule:evenodd;fill:<%= @color %>;} .st1{fill-rule:evenodd;clip-rule:evenodd;fill:#141518;}
      </style>
      <g>
        <path
          class="st0"
          d="M45.54,2.11c32.77-8.78,66.45,10.67,75.23,43.43c8.78,32.77-10.67,66.45-43.43,75.23 c-32.77,8.78-66.45-10.67-75.23-43.43C-6.67,44.57,12.77,10.89,45.54,2.11L45.54,2.11z"
        /><path
          class="st1"
          d="M45.78,32.27c4.3,0,7.78,5.05,7.78,11.27c0,6.22-3.48,11.27-7.78,11.27c-4.3,0-7.78-5.05-7.78-11.27 C38,37.32,41.48,32.27,45.78,32.27L45.78,32.27z M28.12,94.7c16.69-21.63,51.01-21.16,65.78,0.04l2.41-2.39 c-16.54-28.07-51.56-29.07-70.7-0.15L28.12,94.7L28.12,94.7z M77.1,32.27c4.3,0,7.78,5.05,7.78,11.27c0,6.22-3.48,11.27-7.78,11.27 c-4.3,0-7.78-5.05-7.78-11.27C69.31,37.32,72.8,32.27,77.1,32.27L77.1,32.27z"
        />
      </g>
    </svg>
    """
  end

  defp smiling_face_with_sunglasses(assigns) do
    ~H"""
    <svg
      width={@width}
      height={@height}
      viewBox="0 0 36 36"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      aria-hidden="true"
      role="img"
      class={"#{@class} iconify--twemoji"}
      preserveAspectRatio="xMidYMid meet"
    >
      <path
        fill={@color}
        d="M36 18c0 9.941-8.059 18-18 18S0 27.941 0 18S8.059 0 18 0s18 8.059 18 18"
      >
      </path>
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        fill="#292F33"
        d="M1.24 11.018c.24.239 1.438.957 1.677 1.675c.24.717.72 4.784 2.158 5.981c1.483 1.232 7.077.774 8.148.24c2.397-1.195 2.691-4.531 3.115-6.221c.239-.957 1.677-.957 1.677-.957s1.438 0 1.678.956c.424 1.691.72 5.027 3.115 6.221c1.072.535 6.666.994 8.151-.238c1.436-1.197 1.915-5.264 2.155-5.982c.238-.717 1.438-1.435 1.677-1.674c.241-.239.241-1.196 0-1.436c-.479-.478-6.134-.904-12.223-.239c-1.215.133-1.677.478-4.554.478c-2.875 0-3.339-.346-4.553-.478c-6.085-.666-11.741-.24-12.221.238c-.239.239-.239 1.197 0 1.436z"
      >
      </path>
      <path
        fill="#292F33"
        d="M27.335 23.629a.501.501 0 0 0-.635-.029c-.039.029-3.922 2.9-8.7 2.9c-4.766 0-8.662-2.871-8.7-2.9a.5.5 0 0 0-.729.657C8.7 24.472 11.788 29.5 18 29.5s9.301-5.028 9.429-5.243a.499.499 0 0 0-.094-.628z"
      >
      </path>
    </svg>
    """
  end
end
