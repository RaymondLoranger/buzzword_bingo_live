defmodule Buzzword.Bingo.LiveWeb.GameComponents do
  use Buzzword.Bingo.LiveWeb, [:html, :aliases]

  attr :id, :string, required: true
  attr :for, Phoenix.HTML.Form, required: true
  attr :change, :string, required: true
  attr :submit, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  slot :inner_block, required: true

  @spec user_form(Socket.assigns()) :: Rendered.t()
  def user_form(assigns) do
    ~H"""
    <div class="mx-auto flex flex-col items-center text-slate-900 dark:text-slate-50">
      <h1 class="mt-8 mb-2 text-4xl">Welcome!</h1>
      <h4 class="m-2 text-xl text-center">
        First up, we need your name and favorite color:
      </h4>
      <.form
        id={@id}
        for={@for}
        phx-change={@change}
        phx-submit={@submit}
        phx-target={@target}
        class="flex flex-col items-center gap-4"
      >
        <%= render_slot(@inner_block) %>
      </.form>
    </div>
    """
  end

  slot :inner_block, required: true

  def user_fields(assigns) do
    ~H"""
    <div class="flex flex-wrap place-content-center gap-x-5 mt-2 mx-2">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :color, :string, required: true
  attr :field, Phoenix.HTML.FormField, doc: "form field struct from the form"

  def name_field(assigns) do
    ~H"""
    <.input
      phx-1={@color == "#38caf6"}
      phx-2={@color == "#a4deff"}
      phx-3={@color == "#f9cedf"}
      phx-4={@color == "#d3c5f1"}
      phx-5={@color == "#acc9f5"}
      phx-6={@color == "#aeeace"}
      phx-7={@color == "#96d7b9"}
      phx-8={@color == "#fce8bd"}
      phx-9={@color == "#fcd8ac"}
      field={@field}
      placeholder="Name"
      phx-mounted={JS.focus()}
      phx-debounce="750"
      required
      wrapper_class="flex flex-col h-auto mt-4"
      class={[
        "h-8 px-2 pb-3 border-2 rounded-md text-black placeholder-slate-400 dark:placeholder-black",
        "phx-1:border-[#38caf6] phx-2:border-[#a4deff] phx-3:border-[#f9cedf] phx-4:border-[#d3c5f1] phx-5:border-[#acc9f5] phx-6:border-[#aeeace] phx-7:border-[#96d7b9] phx-8:border-[#fce8bd] phx-9:border-[#fcd8ac]",
        "dark:phx-1:bg-[#38caf6] dark:phx-2:bg-[#a4deff] dark:phx-3:bg-[#f9cedf] dark:phx-4:bg-[#d3c5f1] dark:phx-5:bg-[#acc9f5] dark:phx-6:bg-[#aeeace] dark:phx-7:bg-[#96d7b9] dark:phx-8:bg-[#fce8bd] dark:phx-9:bg-[#fcd8ac]",
        "focus:phx-1:ring-[#38caf6] focus:phx-2:ring-[#a4deff] focus:phx-3:ring-[#f9cedf] focus:phx-4:ring-[#d3c5f1] focus:phx-5:ring-[#acc9f5] focus:phx-6:ring-[#aeeace] focus:phx-7:ring-[#96d7b9] focus:phx-8:ring-[#fce8bd] focus:phx-9:ring-[#fcd8ac]"
      ]}
      error_class="!mt-1 !gap-1 dark:!text-rose-300"
    />
    """
  end

  attr :field, Phoenix.HTML.FormField, doc: "form field struct from the form"
  attr :id, :string
  attr :name, :atom
  attr :errors, :list
  attr :colors, :list, required: true
  attr :color, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :click, :string, required: true

  def color_field(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assign(assigns,
        id: field.id,
        name: field.name,
        errors: Enum.map(field.errors, &translate_error/1)
      )

    ~H"""
    <div class="flex flex-col h-auto mt-4" phx-feedback-for={@name}>
      <ul id="user-colors" class="flex flex-wrap place-content-center gap-1.5">
        <li :for={color <- @colors} class="relative">
          <label
            phx-1={color == "#38caf6"}
            phx-2={color == "#a4deff"}
            phx-3={color == "#f9cedf"}
            phx-4={color == "#d3c5f1"}
            phx-5={color == "#acc9f5"}
            phx-6={color == "#aeeace"}
            phx-7={color == "#96d7b9"}
            phx-8={color == "#fce8bd"}
            phx-9={color == "#fcd8ac"}
            title={color}
            class={[
              "phx-1:bg-[#38caf6] phx-2:bg-[#a4deff] phx-3:bg-[#f9cedf] phx-4:bg-[#d3c5f1] phx-5:bg-[#acc9f5] phx-6:bg-[#aeeace] phx-7:bg-[#96d7b9] phx-8:bg-[#fce8bd] phx-9:bg-[#fcd8ac]",
              "flex w-7 m-0.5 aspect-square cursor-pointer border border-gray-500",
              "hover:border-transparent hover:ring-gray-600 hover:ring-1"
            ]}
          >
            <input
              type="radio"
              id={"#{@id}_#{color}"}
              name={@name}
              value={color}
              checked={color == @color}
              phx-target={@target}
              phx-click={@click}
              class="sr-only peer"
            />
            <span class="absolute hidden peer-checked:block top-1 left-2.5 text-black">
              ✓
            </span>
          </label>
        </li>
      </ul>
      <.error
        :for={msg <- @errors}
        error_class="!mt-1 !gap-1 dark:!text-rose-300"
      >
        <%= Phoenix.HTML.raw(msg) %>
      </.error>
    </div>
    """
  end

  attr :text, :string, required: true

  def submit_button(assigns) do
    ~H"""
    <.button class={[
      "my-5 p-1 text-white bg-carrot-orange w-28 rounded-md",
      "hover:bg-carrot-orange-light active:ring-4",
      "focus:outline-none focus:border-transparent focus:ring-2 focus:ring-amber-600"
    ]}>
      <%= @text %>
    </.button>
    """
  end

  attr :id, :string, required: true
  attr :for, Phoenix.HTML.Form, required: true
  attr :change, :string, required: true
  attr :submit, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  slot :inner_block, required: true

  def game_size_form(assigns) do
    ~H"""
    <div>
      <h4 class="text-xl text-center mt-12 mb-5 text-black dark:text-white">
        Select the game size:
      </h4>
      <.form
        id={@id}
        for={@for}
        phx-change={@change}
        phx-submit={@submit}
        phx-target={@target}
        class="mx-14 md:w-3/4 md:mx-auto flex flex-col items-center gap-2"
      >
        <%= render_slot(@inner_block) %>
      </.form>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, doc: "form field struct from the form"
  attr :id, :string
  attr :name, :atom
  attr :value, :integer
  attr :errors, :list

  def game_size_field(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assign(assigns,
        id: field.id,
        name: field.name,
        value: field.value,
        errors: Enum.map(field.errors, &translate_error/1)
      )

    ~H"""
    <div class="w-full flex flex-col items-center" phx-feedback-for={@name}>
      <div
        id="game-sizes"
        class="w-full md:w-5/6 flex justify-evenly items-start flex-wrap place-content-center gap-6 text-black dark:text-white"
      >
        <label class="cursor-pointer">
          <input
            type="radio"
            id={"#{@id}_5"}
            name={@name}
            value={5}
            checked={@value == 5}
            phx-mounted={JS.focus()}
            class="ml-12 mt-2 mb-4"
          />
          <.grid_size text="5 x 5" />
          <.grid_glyph size={5} />
        </label>
        <label class="cursor-pointer">
          <input
            type="radio"
            id={"#{@id}_4"}
            name={@name}
            value={4}
            checked={@value == 4}
            class="ml-12 mt-2 mb-4"
          />
          <.grid_size text="4 x 4" />
          <.grid_glyph size={4} />
        </label>
        <label class="cursor-pointer">
          <input
            type="radio"
            id={"#{@id}_3"}
            name={@name}
            value={3}
            checked={@value == 3}
            class="ml-12 mt-2 mb-4"
          />
          <.grid_size text="3 x 3" />
          <.grid_glyph size={3} />
        </label>
      </div>
      <.error
        :for={msg <- @errors}
        error_class="!mt-1 !gap-1 dark:!text-rose-300"
      >
        <%= Phoenix.HTML.raw(msg) %>
      </.error>
    </div>
    """
  end

  slot :game_url, required: true
  slot :inner_block, required: true

  def game_layout(assigns) do
    ~H"""
    <div id="game-layout">
      <section id="game-url-pair" class="flex justify-center">
        <span class="field-button-pair my-6 w-2/3">
          <%= render_slot(@game_url) %>
        </span>
      </section>

      <section
        id="playground"
        class="flex flex-col sm:flex-row justify-center gap-3 h-full mx-2"
      >
        <%= render_slot(@inner_block) %>
      </section>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :value, :string, required: true

  def game_url_field(assigns) do
    ~H"""
    <input
      id={@id}
      type="text"
      title={@value}
      value={@value}
      readonly
      class="truncate"
    />
    """
  end

  attr :click, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true

  def copy_url_button(assigns) do
    ~H"""
    <button title="Copy game URL" phx-click={@click} phx-target={@target}>
      <.icon name="hero-clipboard-document" class="mb-1" />
    </button>
    """
  end

  attr :game_size, :integer, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true

  def board(assigns) do
    ~H"""
    <div
      phx-5={@game_size == 5}
      phx-4={@game_size == 4}
      phx-3={@game_size == 3}
      id="board"
      phx-update={@update}
      class="grid phx-5:grid-cols-5 phx-4:grid-cols-4 phx-3:grid-cols-3 gap-2 sm:w-[69%] w-full"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :square, Square, required: true
  attr :id, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :click, :string, required: true
  attr :phrase, :string, required: true
  attr :keyup, :string, required: true
  attr :key, :string, required: true

  # Use tabindex to make squares focusable...
  def square(assigns) do
    ~H"""
    <div
      tabindex="0"
      phx-1={@square.marked_by && @square.marked_by.color == "#38caf6"}
      phx-2={@square.marked_by && @square.marked_by.color == "#a4deff"}
      phx-3={@square.marked_by && @square.marked_by.color == "#f9cedf"}
      phx-4={@square.marked_by && @square.marked_by.color == "#d3c5f1"}
      phx-5={@square.marked_by && @square.marked_by.color == "#acc9f5"}
      phx-6={@square.marked_by && @square.marked_by.color == "#aeeace"}
      phx-7={@square.marked_by && @square.marked_by.color == "#96d7b9"}
      phx-8={@square.marked_by && @square.marked_by.color == "#fce8bd"}
      phx-9={@square.marked_by && @square.marked_by.color == "#fcd8ac"}
      class={[
        "bg-white phx-1:bg-[#38caf6] phx-2:bg-[#a4deff] phx-3:bg-[#f9cedf] phx-4:bg-[#d3c5f1] phx-5:bg-[#acc9f5] phx-6:bg-[#aeeace] phx-7:bg-[#96d7b9] phx-8:bg-[#fce8bd] phx-9:bg-[#fcd8ac]",
        "shadow aspect-square grid gap-2 grid-rows-3 rounded-md text-slate-600 border border-slate-300",
        "hover:scale-95 hover:border-slate-400 hover:bg-wheatfield hover:cursor-pointer",
        "focus:outline-none focus:border-carrot-orange focus:ring-1 focus:ring-carrot-orange",
        "active:ring-4 active:ring-carrot-orange active:border-transparent"
      ]}
      id={@id}
      phx-target={@target}
      phx-click={@click}
      phx-value-phrase={@phrase}
      phx-keyup={@keyup}
      phx-key={@key}
    >
      <span class="text-xs leading-3 self-start justify-self-start p-0.5 sm:p-1">
        <%= if @square.marked_by, do: @square.marked_by.name, else: "" %>
      </span>

      <span class={[
        "#{word_break(@square.phrase)}",
        "text-xs leading-3 sm:text-sm sm:leading-3 md:text-base md:leading-4 tracking-tightest sm:tracking-tighter md:tracking-tight font-medium self-center justify-self-center text-center p-0.5 sm:p-1"
      ]}>
        <%= @square.phrase %>
      </span>

      <span class="text-xs leading-3 self-end justify-self-end p-0.5 sm:p-1">
        <%= @square.points %>
      </span>
    </div>
    """
  end

  # type is Player or nil...
  attr :winner, :any, required: true

  def game_over?(assigns) do
    ~H"""
    <div :if={@winner} class="absolute top-1/3 animate-ping">
      <span :if={@winner.name == "X"}>
        <span>No winner!</span>
        <br /><br />
        <span>
          <.sad_face
            color={@winner.color}
            width="90px"
            height="90px"
            class="inline"
          />
        </span>
      </span>

      <span :if={@winner.name != "X"}>
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
      </span>
    </div>
    """
  end

  slot :inner_block, required: true

  def chatroom(assigns) do
    ~H"""
    <div id="chatroom" class="flex flex-col gap-0 sm:w-[28%] w-full">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :streams, :map, required: true
  attr :player, Player, required: true

  def players_panel(assigns) do
    ~H"""
    <div class="text-white bg-deluge p-2 rounded-t-md">
      Who's Playing
    </div>
    <ul
      id="players"
      phx-update="stream"
      class="border-x-2 border-b-2 border-deluge rounded-b-md mb-0 bg-white"
    >
      <li
        :for={{dom_id, player} <- @streams.players}
        id={dom_id}
        class="border-b border-gray-200 p-1 whitespace-nowrap last:border-b-0 tracking-tight flex justify-between items-baseline"
      >
        <span>
          <span
            phx-1={player.meta.color == "#38caf6"}
            phx-2={player.meta.color == "#a4deff"}
            phx-3={player.meta.color == "#f9cedf"}
            phx-4={player.meta.color == "#d3c5f1"}
            phx-5={player.meta.color == "#acc9f5"}
            phx-6={player.meta.color == "#aeeace"}
            phx-7={player.meta.color == "#96d7b9"}
            phx-8={player.meta.color == "#fce8bd"}
            phx-9={player.meta.color == "#fcd8ac"}
            class={[
              "phx-1:bg-[#38caf6] phx-2:bg-[#a4deff] phx-3:bg-[#f9cedf] phx-4:bg-[#d3c5f1] phx-5:bg-[#acc9f5] phx-6:bg-[#aeeace] phx-7:bg-[#96d7b9] phx-8:bg-[#fce8bd] phx-9:bg-[#fcd8ac]",
              "aspect-square px-2 mx-1.5 rounded-sm text-xs"
            ]}
          />
          <span
            phx-1={player.name == @player.name}
            class="tracking-tight phx-1:underline phx-1:underline-offset-4"
          >
            <%= player.name %>
          </span>
        </span>

        <span class="tracking-tighter text-sm ml-2">
          <span class="hidden sm:inline lg:hidden">
            <%= player.meta.score %> points
          </span>
          <span class="inline sm:hidden lg:inline">
            <%= player.meta.score %> points (<%= player.meta.marked %>
            <%= ngettext("square", "squares", player.meta.marked) %>)
          </span>
        </span>
      </li>
    </ul>
    """
  end

  attr :streams, :map, required: true

  def messages_panel(assigns) do
    ~H"""
    <div class="text-white bg-deluge p-2 rounded-t-md mt-2">
      What's Up?
    </div>
    <ul
      id="messages"
      phx-update="stream"
      phx-hook="ScrollToEnd"
      class="flex-auto border-x-2 border-b-2 border-deluge rounded-b-md bg-white overflow-y-auto min-h-[35px]"
    >
      <li
        :for={{dom_id, message} <- @streams.messages}
        id={dom_id}
        class="border-b border-gray-200 p-1 tracking-tight"
      >
        <span
          phx-1={message.sender.color == "#38caf6"}
          phx-2={message.sender.color == "#a4deff"}
          phx-3={message.sender.color == "#f9cedf"}
          phx-4={message.sender.color == "#d3c5f1"}
          phx-5={message.sender.color == "#acc9f5"}
          phx-6={message.sender.color == "#aeeace"}
          phx-7={message.sender.color == "#96d7b9"}
          phx-8={message.sender.color == "#fce8bd"}
          phx-9={message.sender.color == "#fcd8ac"}
          class={[
            "phx-1:bg-[#38caf6] phx-2:bg-[#a4deff] phx-3:bg-[#f9cedf] phx-4:bg-[#d3c5f1] phx-5:bg-[#acc9f5] phx-6:bg-[#aeeace] phx-7:bg-[#96d7b9] phx-8:bg-[#fce8bd] phx-9:bg-[#fcd8ac]",
            "pl-1.5 pr-0.5 mr-1 rounded-sm"
          ]}
        >
          <%= message.sender.name %>
        </span>
        <span><%= message.text %></span>
      </li>
    </ul>
    """
  end

  attr :change, :string, required: true
  attr :submit, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  slot :inner_block, required: true

  def message_form(assigns) do
    ~H"""
    <div id="message-form" class="mt-2">
      <form phx-change={@change} phx-submit={@submit} phx-target={@target}>
        <span class="field-button-pair w-full">
          <%= render_slot(@inner_block) %>
        </span>
      </form>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :value, :string, required: true

  def message_input_field(assigns) do
    ~H"""
    <input
      type="text"
      name={@name}
      value={@value}
      phx-mounted={JS.focus()}
      placeholder="Enter your message..."
      class="truncate"
    />
    """
  end

  attr :disabled, :boolean, required: true

  def message_submit_button(assigns) do
    ~H"""
    <button title="Send message" type="submit" disabled={@disabled}>
      <.icon name="hero-chat-bubble-left" class="mb-1" />
    </button>
    """
  end

  ## Private functions

  @spec word_break(String.t()) :: String.t()
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

  attr :text, :string, required: true

  @spec grid_size(Socket.assigns()) :: Rendered.t()
  defp grid_size(assigns) do
    ~H"""
    <span class="leading-4 tracking-tighter float-right mr-10 mt-2">
      <%= @text %>
    </span>
    """
  end

  attr :size, :integer, required: true

  defp grid_glyph(assigns) do
    ~H"""
    <div
      phx-5={@size == 5}
      phx-4={@size == 4}
      phx-3={@size == 3}
      class="w-36 aspect-square grid phx-5:grid-cols-5 phx-4:grid-cols-4 phx-3:grid-cols-3 phx-5:gap-1 phx-4:gap-1.5 phx-3:gap-2"
    >
      <div
        :for={_n <- 1..(@size * @size)}
        class="p-1 aspect-square bg-wedgewood"
      />
    </div>
    """
  end

  attr :width, :string, required: true
  attr :height, :string, required: true
  attr :class, :string, required: true
  attr :color, :string, required: true

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

  attr :width, :string, required: true
  attr :height, :string, required: true
  attr :class, :string, required: true
  attr :color, :string, required: true

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
