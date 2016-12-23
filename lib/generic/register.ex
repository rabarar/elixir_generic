
defmodule Generic.Registry do
  use GenServer

  # API
  
  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :registry)
  end

  def whereis_name(server_name) do
    GenServer.call(:registry, {:whereis_name, server_name})
  end

  def register_name(server_name, pid) do
    GenServer.call(:registry, {:register_name, server_name, pid})
  end

  def ungegister_name(server_name) do
    GenServer.cast(:registry, {:unregister_name, server_name})
  end

  def send(server_name, message) do
    case whereis_name(server_name) do
      :undefined ->
        {:badarg, {server_name, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # SERVER

  def init(_) do
    # use a Map to store registery i.e. %{"server name" => pid}
    {:ok, Map.new}
  end

  def handle_call({:whereis_name, server_name}, _from, state) do
    {:reply, Map.get(state, server_name, :undefined), state}
  end

  def handle_call({:register_name, server_name, pid}, _from, state) do
    # add the serve name and pid to the map
    case Map.get(state, server_name) do
        nil ->
          Process.monitor(pid)
          {:reply, :yes, Map.put(state, server_name, pid)}

        _ ->
          {:reply, :no, state}
    end
  end

  def handle_info({:DOWN,_,:process, pid, _}, state) do
    {:noreply, remove_pid(state,pid)}
  end

  def handle_cast({:unregister_name, server_name}, state) do
    # remove the element from the map
    {:noreply, Map.delete(state, server_name)}
  end

  def remove_pid(state, pid_removed) do
    remove = fn {_key,pid} -> pid != pid_removed end
    Enum.filter(state, remove) |> Enum.into(%{})
  end
end

