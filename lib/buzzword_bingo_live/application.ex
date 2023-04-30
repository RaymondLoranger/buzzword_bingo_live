defmodule Buzzword.Bingo.Live.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Buzzword.Bingo.LiveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Buzzword.Bingo.Live.PubSub},
      # Start the Endpoint (http/https)
      Buzzword.Bingo.LiveWeb.Endpoint,
      Buzzword.Bingo.LiveWeb.Presence
      # Start a worker by calling: Buzzword.Bingo.Live.Worker.start_link(arg)
      # {Buzzword.Bingo.Live.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Buzzword.Bingo.Live.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Buzzword.Bingo.LiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
