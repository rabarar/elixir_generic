defmodule Generic.Server do
  use GenServer

  #API
  #
  @server_name :generic_server
  
  def start_link do
    GenServer.start_link(__MODULE__, [], name: @server_name)
  end

  def add_message( message) do
    GenServer.cast(@server_name, {:add_message, message})
  end

  def get_messages() do
    GenServer.call(@server_name, :get_messages)
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
