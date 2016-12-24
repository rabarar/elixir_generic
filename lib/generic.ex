defmodule Generic do

  def run_generic do
    Generic.Registry.start_link
    Generic.Supervisor.start_link(:sup1, %{worker: Generic.Server, opts: %{}})
    Generic.Supervisor.start_server(:sup1, "s1")
  end

  def run_tcp do
    Generic.Registry.start_link
    Generic.Supervisor.start_link(:sup2, %{worker: TCPServer, opts: %{port: 4000, service: "dothis"}})
    Generic.Supervisor.start_server(:sup2, "s2")
  end
end
