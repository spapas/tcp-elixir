defmodule Tcp.ConnectionHandler do
  use ThousandIsland.Handler

  @impl ThousandIsland.Handler
  def handle_connection(socket, state) do
    ThousandIsland.Socket.send(socket, "Hello, World")
    IO.puts("Connected!")
    {:continue, state}
  end

  @impl ThousandIsland.Handler
  def handle_data(msg, _socket, state) do
    IO.puts(msg)
    {:continue, state}
  end

  def handle_info({:send, msg}, {socket, state}) do
    ThousandIsland.Socket.send(socket, msg)
    {:noreply, {socket, state}}
  end
end
