defmodule Poker.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PokerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Poker.PubSub},
      # Start the Endpoint (http/https)
      PokerWeb.Endpoint
      # Start a worker by calling: Poker.Worker.start_link(arg)
      # {Poker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Poker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PokerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
