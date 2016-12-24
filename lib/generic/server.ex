defmodule Generic.Server do
  use GenServer

  @registry Generic.Registry
  @server   :server_name

  #API
  #
  
  def start_link(opts, name) do
    # use a via tuple to register the name
    GenServer.start_link(__MODULE__, [opts], name: via(name))
  end

  def get_registry_name do
    @server
  end

  def add_message(server_name, message) do
    GenServer.cast(via(server_name), {:add_message, message})
  end

  def get_messages(server_name) do
    GenServer.call(via(server_name), :get_messages)
  end

  def via(server_name) do
    # via tuple format: {:via, mod, term}
    {:via, @registry, {@server, server_name}}
  end

  #SERVER
  #

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, []}
  end

end
