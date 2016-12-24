# Generic

**A generic example of a :gproc registered, supervised collection of named homogenous servers**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `generic` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:generic, "~> 0.1.0"}]
    end
    ```

    or with github

   ```elixir
    defp deps do
	[{:generic, github: "rabarar/elixir_generic"}]
    end
    ```


  2. Ensure `generic` is started before your application:

    ```elixir
    def application do
      [applications: [:generic]]
    end
    ```


## Example usage


## start a supervisor  

```
Generic.Supervisor.start_link(:super_a, %{worker: Generic.Server, opts: %{}}) ## for a GenServer style server
Generic.Supervisor.start_link(:super_b, %{worker: TCPServer, opts: %{port: 4000}}) ## for a tcp server accepting connections
```

## start a server under a supervisor 
```
Generic.Supervisor.start_server(:super_a, "servername")
```

## send and receive messages to a server
```
Generic.Server.add_message("servername", "message")
Generic.Server.get_messages("servername")
```

```
:gproc.where({:n, :l, {:server_name, "servername"}}) 
```


