defmodule Tcp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: Tcp.ServerSupervisor, strategy: :one_for_one},
      Supervisor.child_spec({Task, fn -> Tcp.Listener.listen(4040) end}, restart: :permanent),
      Tcp.Registry
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tcp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
