defmodule Aspirin.PingMonitor do
  use GenServer

  ## API

  def start_link(ip) do
    GenServer.start_link(__MODULE__, {:ok, ip}, [])
  end

  def stop(server) do
    GenServer.stop(server)
  end

  ## Callbacks

  def init({:ok, ip}) do
    {:ok, manager} = GenEvent.start_link([])
    GenEvent.add_handler(manager, Aspirin.PingMonitor.SocketHandler, [])
    Process.send(self(), :ping, [])
    {:ok, %{ip: ip, event_manager: manager, last_ok_time: time_now}}
  end

  @interval 5000

  def handle_info(:ping, %{ip: ip, last_ok_time: last_ok_time} = state) do
    result = ping(ip)
    new_state = update_ok_time(result, state)
    notify(result, new_state)
    Process.send_after(self(), :ping, @interval)
    {:noreply, new_state}
  end

  def ping(ip) when is_binary(ip) do
    [ret] = ip |> String.to_charlist |> :gen_icmp.ping
    case ret do
      {:ok, _, _, _, _, _} -> :ok
      _                    -> :error
    end
  end

  defp update_ok_time(ping_result, state) when ping_result in [:ok, :error] do
    case ping_result do
      :ok    -> state
      :error -> %{state | last_ok_time: time_now}
    end
  end

  defp notify(result, %{ip: ip, last_ok_time: last_ok_time,
                        event_manager: manager}) do
    GenEvent.sync_notify(manager, {:test_ping, ip, result, last_ok_time})
  end

  defp time_now, do: :os.system_time(:milli_seconds)
end
