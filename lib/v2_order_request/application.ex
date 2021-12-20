defmodule V2OrderRequest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      V2OrderRequest.Repo,
      # Start the Telemetry supervisor
      V2OrderRequestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: V2OrderRequest.PubSub},
      # Start the Endpoint (http/https)
      V2OrderRequestWeb.Endpoint
      # Start a worker by calling: V2OrderRequest.Worker.start_link(arg)
      # {V2OrderRequest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: V2OrderRequest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    V2OrderRequestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
