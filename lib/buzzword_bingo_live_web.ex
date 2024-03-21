defmodule Buzzword.Bingo.LiveWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use Buzzword.Bingo.LiveWeb, :controller
      use Buzzword.Bingo.LiveWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: Buzzword.Bingo.LiveWeb.Layouts]

      import Plug.Conn
      import Buzzword.Bingo.LiveWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {Buzzword.Bingo.LiveWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import Buzzword.Bingo.LiveWeb.CoreComponents
      import Buzzword.Bingo.LiveWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: Buzzword.Bingo.LiveWeb.Endpoint,
        router: Buzzword.Bingo.LiveWeb.Router,
        statics: Buzzword.Bingo.LiveWeb.static_paths()
    end
  end

  def imports do
    quote do
      import Phoenix.LiveView,
        only: [
          push_patch: 2,
          put_flash: 3,
          stream: 4,
          stream_delete: 3,
          stream_insert: 3
        ]
    end
  end

  def aliases do
    quote do
      alias Buzzword.Bingo.LiveWeb.{
        Endpoint,
        GameComponents,
        GameInfo,
        GameLayout,
        GameParams,
        GamePresence,
        GameSizeForm,
        GameTerminate,
        MessageForm,
        Presence,
        UserForm
      }

      alias Buzzword.Bingo.Live.{GameSize, User}
      alias Buzzword.Bingo.{Engine, Game, Player, Square, Summary}
      alias Ecto.UUID
      alias Phoenix.LiveView
      alias Phoenix.LiveView.{Rendered, Socket}
      alias Phoenix.Socket.Broadcast
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(whiches) when is_list(whiches) do
    for which <- whiches do
      quote do
        unquote(apply(__MODULE__, which, []))
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
