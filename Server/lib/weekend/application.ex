defmodule Weekend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Weekend.Repo,
      # Start the Telemetry supervisor
      WeekendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Weekend.PubSub},
      # Start the Endpoint (http/https)
      WeekendWeb.Endpoint
      # Start a worker by calling: Weekend.Worker.start_link(arg)
      # {Weekend.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Weekend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WeekendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
