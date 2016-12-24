defmodule TCP.Service.A do

    require Logger

    @shutdown "bye"

    def  serve(socket) do
      
      start(socket)
      service(socket)
    end


    defp service(socket) do
      case read_line(socket) do
        {:ok, :closed} ->
          Logger.info "Connection closed by peer"

        {:ok, :shutdown} ->
          Logger.info "Connection shutdown by peer"

        {:ok, data} ->
          case data do
            "name" ->
              write_line("my name is hank\r\n", socket)

             _ ->
              write_line("huh? I don't understan that command\r\n", socket)
          end
          service(socket)
      end

    end

    defp  start(socket) do
      write_line("welcome to service A\r\n", socket)
    end

    defp  stop(socket) do
      write_line("Thanks for using service A\r\n", socket)
    end


    defp read_line(socket) do

      case :gen_tcp.recv(socket, 0) do

        {:ok, data} ->

          case nocrlf_data = data |> String.replace("\r", "") |> String.replace("\n", "") do

            @shutdown ->
              stop(socket)
              :gen_tcp.shutdown(socket, :read_write)
              Logger.info "Got shutdown"
              {:ok, :shutdown}

            _ ->
              Logger.debug "received [#{inspect data}]"
              {:ok, nocrlf_data}
          end

        {:error, :closed}  -> {:ok, :closed}

        _ -> {:error, :unknown}

      end
    end

    defp write_line(line, socket) do
      :gen_tcp.send(socket, line)
    end


end
