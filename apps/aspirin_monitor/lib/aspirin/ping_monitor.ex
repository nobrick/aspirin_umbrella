defmodule Aspirin.PingMonitor do
  use GenServer

  ## API

  def start_link(ip) do
    GenServer.start_link(__MODULE__, {:ok, ip}, [])
  end

  ## Callbacks

  def init({:ok, ip}) do
    {:ok, manager} = GenEvent.start_link([])
    # GenEvent.add_handler(manager, Aspirin.PingMonitor.SocketHandler, [])
    Process.send(self(), :ping, [])
    {:ok, %{ip: ip, event_manager: manager, last_ok_time: time_now}}
  end

  @interval 5000

  def handle_info(:ping, %{ip: ip} = state) do
    ping(ip) |> IO.inspect
    Process.send_after(self(), :ping, @interval)
    {:noreply, state}
  end

  def ping(ip) when is_binary(ip) do
    [ret] = ip |> String.to_charlist |> :gen_icmp.ping
    case ret do
      {:ok, _, _, _, _, _} -> :ok
      _                    -> :error
    end
  end

  defp time_now, do: :os.system_time(:milli_seconds)
end
