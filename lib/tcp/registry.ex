defmodule Tcp.Registry do
  use GenServer

  @impl true
  def init(:ok) do
    IO.puts "STARTING TCP Server registry"

    {:ok, []}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:register, pid, client}, state) do
    {:noreply,  [{pid, client}|state]}
  end

  @impl true
  def handle_cast({:unregister, pid}, state) do
    new_state = state |> Enum.filter(fn {p, _c} -> p != pid end)
    {:noreply, new_state}
  end


  ## Client API

  @doc """
  Starts the gen server
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def register(pid, client) do
    GenServer.cast(__MODULE__, {:register, pid, client})
  end

  def unregister(pid) do
    GenServer.cast(__MODULE__, {:unregister, pid})
  end



end
