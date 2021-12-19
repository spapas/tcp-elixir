defmodule Tcp.Client do
  use GenServer, restart: :temporary

  @impl true
  def init(:ok) do
    {:ok, socket} = :gen_tcp.connect(
        {127,0,0,1},
        4040,
        [:binary, active: true, packet: 1]
     )
     {:ok, socket}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:send_message, message}, _from, socket) do
    :ok = :gen_tcp.send(socket, message)
    {:reply, socket, socket}
  end

  @impl true
  def handle_info({:tcp, _socket, message}, state) do
    IO.puts "Got message (client) #{inspect(message)}"
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, socket}, state) do
    IO.puts "Tcp closed for #{inspect(socket)}"
    {:stop, :normal, state}
  end



   ## Client API

  @doc """
  Starts the gen server
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :state)
  end

  def send_message(message) do
    GenServer.call(__MODULE__, {:send_message, message})
  end



end
