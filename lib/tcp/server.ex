defmodule Tcp.Server do
  use GenServer, restart: :temporary

  @impl true
  def init(socket: socket) do
    IO.puts "STARTING TCP Server for #{inspect(socket)}"

    :timer.send_interval(5000, self(), :tick)

    {:ok, socket: socket}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({:tcp, _socket, message}, state) do
    IO.puts "Got message (server) #{inspect(message)}"
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, socket}, state) do
    IO.puts "Tcp closed for #{inspect(socket)}"
    Tcp.Registry.unregister(self())
    {:stop, :normal, state}
  end

  def handle_info(:tick , [socket: socket]=state) do
    IO.puts "TICK #{DateTime.utc_now} #{inspect(socket)}"

    {:noreply, state}

    :gen_tcp.send(socket, "koko")

    {:noreply, state}
  end

  ## Client API

  @doc """
  Starts the gen server
  """
  def start_link(socket: socket) do
    GenServer.start_link(__MODULE__, socket: socket)
  end

  def get_state() do
    GenServer.call(__MODULE__, :state)
  end



end
