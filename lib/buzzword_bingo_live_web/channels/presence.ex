defmodule Buzzword.Bingo.LiveWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :buzzword_bingo_live,
    pubsub_server: Buzzword.Bingo.Live.PubSub
end
