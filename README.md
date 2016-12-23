# Generic

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `generic` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:generic, "~> 0.1.0"}]
    end
    ```

  2. Ensure `generic` is started before your application:

    ```elixir
    def application do
      [applications: [:generic]]
    end
    ```


## Example usage

## start a registry and a supervisor 

```
Generic.Registry.start_link
Generic.Supervisor.start_link
```

## start a server under a supervisor 
```
Generic.Supervisor.start_server("servername")
```

## send and receive messages to a server
```
Generic.Server.add_message("servername", "message")
Generic.Server.get_messages("servername")
```

## get the pid of a registers server although you shouldn't need it other than to explicitly manipulate the process - i.e.
## Process.exit(pid, :kill) for example
```
Generic.Registry.whereis_name({Generic.Server.get_registry_name, "servername"})
```


