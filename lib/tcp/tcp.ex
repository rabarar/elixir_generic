defmodule TCPServer do

    require Logger

    def start_link(opts, name) do
      # use a via tuple to register the name
      GenServer.start_link(__MODULE__, opts, name: Generic.Server.via(name))
    end

    def init(opts) do
      Logger.info "init: Accepting connections on port #opts.port}"
      Task.start(fn -> accept(opts.port) end)
      {:ok, opts.port}
    end

    def accept(port) do
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
      loop_acceptor(socket)
    end

    defp loop_acceptor(socket) do
      {:ok, client} = :gen_tcp.accept(socket)
      serve(client)
      loop_acceptor(socket)
    end

    defp serve(socket) do
      case read_line(socket) do
        {:ok, :closed} ->
          Lopgger.info "Connection closed by peer"

        {:ok, data} ->
          write_line(data, socket)
          serve(socket)
      end

    end

    defp read_line(socket) do
      case :gen_tcp.recv(socket, 0) do
        {:ok, data} -> {:ok, data}

        {:error, :closed}  -> {:ok, :closed}

        _ -> {:error, :unknown}

      end
    end

    defp write_line(line, socket) do
      :gen_tcp.send(socket, line)
    end

end
