defmodule Messenger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MessengerWeb.Telemetry,
      # Start the Ecto repository
      Messenger.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Messenger.PubSub},
      # Start Finch
      {Finch, name: Messenger.Finch},
      # Start the Endpoint (http/https)
      MessengerWeb.Endpoint
      # Start a worker by calling: Messenger.Worker.start_link(arg)
      # {Messenger.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Messenger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MessengerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
