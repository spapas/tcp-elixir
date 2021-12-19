defmodule Tcp.Listener do
  require Logger

  # Packet can be
  # :line to return the next line as a pcket
  # 0 to return the next value it receives as packet
  # 1 will read a byte and then return a packet with as many bytes as this number. I.e if it gets
  # the byte 32 it will return the next 32 bytes as a packet.
  # 2 will read the next 2 bytes to get the packet size (i.e packet size = 0-65535)
  def listen(port) do
    Process.register(self(), :listener)
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: 1, active: true, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = DynamicSupervisor.start_child(Tcp.ServerSupervisor, {Tcp.Server, socket: client})
    Tcp.Registry.register(pid, client)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end
end
