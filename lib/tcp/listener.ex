defmodule Tcp.Listener do
  require Logger

  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: true, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    # {:ok, pid} = Task.Supervisor.start_child(Tcp.TaskSupervisor, fn -> serve(client) end)
    {:ok, pid} = DynamicSupervisor.start_child(Tcp.ServerSupervisor, {Tcp.Server, socket: client})
    Tcp.Registry.register(pid, client)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end


end
