
defmodule Generic.Supervisor do
  use Supervisor

  #@supervisor :supervisor

  def start_link(sup, %{worker: worker, opts: opts}) do
    Supervisor.start_link(__MODULE__, %{worker: worker, opts: opts}, name: sup)
  end


  def start_server(sup, name) do
    Supervisor.start_child(sup, [name])
  end

  def init(%{worker: worker, opts: opts}) do
    IO.puts "init: opts = #{inspect opts}"
    children = [
      worker(worker, [opts])
    ]

    IO.puts "attempting to supervisor children..."
    
    # no process is started with :simple_one_for_one as opposed to :one_for_one, until we call start_child/2 in start_server/1
    supervise(children, strategy: :simple_one_for_one)
  end
end
