defmodule TCPServer do

    require Logger

    def start_link(opts, name) do
      # use a via tuple to register the name
      GenServer.start_link(__MODULE__, opts, name: Generic.Server.via(name))
    end

    def init(opts) do

      case Map.has_key?(opts, :service) do
        true ->
          Logger.info "TCPServer.init: Accepting connections on port #{opts.port} and server #{opts.service}"
          Task.start(fn -> accept(opts.port, opts.service) end)
        false ->
          Logger.info "TCPServer.init: Accepting connections on port #{opts.port}"
          Task.start(fn -> accept(opts.port, :echo) end)
      end
      
      {:ok, opts}
    end

    def accept(port, service) do
      # The options below mean:
      #
      # 1. `:binary` - receives data as binaries (instead of lists)
      # 2. `packet: :line` - receives data line by line
      # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
      # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
      #
      {:ok, socket} = :gen_tcp.listen(port,
                        [:binary, packet: :line, active: false, reuseaddr: true])
      Logger.info "Accepting connections on port #{port}"
      loop_acceptor(socket, service)
    end

    defp loop_acceptor(socket, service) do
      {:ok, client} = :gen_tcp.accept(socket)

      case service do
        :echo ->
            serve(client)
        _ ->
            service.serve(client)
      end

      loop_acceptor(socket, service)
    end

    defp serve(socket) do
      case read_line(socket) do
        {:ok, :closed} ->
          Logger.info "Connection closed by peer"

        {:ok, :shutdown} ->
          Logger.info "Connection shutdown by peer"

        {:ok, data} ->
          write_line(data, socket)
          serve(socket)
      end

    end

    defp read_line(socket) do
      case :gen_tcp.recv(socket, 0) do
        {:ok, data} ->
          case data |> String.replace("\r", "") |> String.replace("\n", "") do
            "bye" -> 
            :gen_tcp.shutdown(socket, :read_write)
            Logger.info "Got shutdown"
              {:ok, :shutdown}

            _ ->
              Logger.info "received [#{inspect data}]"
              {:ok, data}
          end

        {:error, :closed}  -> {:ok, :closed}

        _ -> {:error, :unknown}

      end
    end

    defp write_line(line, socket) do
      :gen_tcp.send(socket, line)
    end

end
