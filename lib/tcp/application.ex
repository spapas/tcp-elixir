defmodule Tcp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      #{Task.Supervisor, name: Tcp.TaskSupervisor},
      {DynamicSupervisor, name: Tcp.ServerSupervisor, strategy: :one_for_one},
      {Task, fn -> Tcp.Listener.listen(4040) end},
      Tcp.Registry,
      {ThousandIsland, port: 4041, handler_module: Tcp.ConnectionHandler, transport_options: [packet: 1]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tcp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
