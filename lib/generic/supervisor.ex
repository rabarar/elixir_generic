
defmodule Generic.Supervisor do
  use Supervisor

  @supervisor :supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @supervisor)
  end


  def start_server(name) do
    Supervisor.start_child(@supervisor, [name])
  end

  def init(_) do
    children = [
      worker(Generic.Server, [])
    ]

    # no process is started with :simple_one_for_one as opposed to :one_for_one, until we call start_child/2 in start_server/1
    supervise(children, strategy: :simple_one_for_one)
  end
end
