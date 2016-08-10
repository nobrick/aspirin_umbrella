defmodule Aspirin.PingMonitor.SocketHandler do
  use GenEvent
  import Aspirin.Endpoint, only: [broadcast!: 3]
  import Aspirin.MonitorEventView, only: [css_identity: 2]

  def handle_event({:test_ping, addr, result, last_ok_time} = t, _state) do
    msg = %{addr: addr, timestamp: timestamp, last_ok_time: last_ok_time,
            identity: css_identity(:ping, addr)}
          |> msg_with_result(result)
    broadcast!("status:all", "test_ping", msg)
    {:ok, []}
  end

  defp msg_with_result(msg, ping_result) when is_map(msg) do
    value = case ping_result do
              :ok    -> :success
              :error -> :failure
            end
    Map.put(msg, :body, value)
  end

  defp timestamp do
    :os.system_time(:milli_seconds)
  end
end
