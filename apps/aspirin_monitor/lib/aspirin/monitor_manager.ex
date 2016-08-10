defmodule Aspirin.MonitorManager do
  use GenServer
  alias Aspirin.MonitorEvent
  alias Aspirin.PortMonitor
  alias Aspirin.PingMonitor
  import Ecto.Query, only: [from: 2]

  @types ~w(port ping)

  ## API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def sync_repo(pid) do
    GenServer.call(pid, :sync_repo)
  end

  def reset(pid) do
    GenServer.call(pid, :reset)
  end

  def add_port_monitor(pid, id, ip, port) do
    opts = %{pid: pid, id: id, ip: ip, port: port, type: "port"}
    GenServer.call(pid, {:add_monitor, opts})
  end

  def add_ping_monitor(pid, id, ip) do
    opts = %{pid: pid, id: id, ip: ip, type: "ping"}
    GenServer.call(pid, {:add_monitor, opts})
  end

  def remove_monitor(pid, id) do
    GenServer.call(pid, {:remove_monitor, id})
  end

  ## Callbacks

  def init(:ok) do
    {:ok, initial_state}
  end

  def handle_call(:reset, _from, state) do
    {:reply, :ok, stop_all(state)}
  end

  def handle_call(:sync_repo, _from, %{monitors: _monitors} = state) do
    events = from(m in MonitorEvent, where: m.enabled == true)
             |> Aspirin.Repo.all

    new = Enum.reduce(events, stop_all(state), fn(mon, acc) ->
      acc |> add_monitor(mon)
    end)
    {:reply, :ok, new}
  end

  def handle_call({:add_monitor, %{type: type} = monitor}, _from, state)
      when type in @types do
    {:reply, :ok, state |> add_monitor(monitor)}
  end

  def handle_call({:remove_monitor, id}, _from, %{monitors: monitors} = state)
      when is_integer(id) do
    case monitors do
      %{^id => %{pid: pid, type: type}} ->
        stop_monitor(pid)
        {:reply, :ok, %{monitors: Map.delete(monitors, id)}}
      _ ->
        {:reply, :ok, state}
    end
  end

  ## Helpers

  defp stop_all(%{monitors: monitors}) do
    monitors |> Map.values |> Enum.each(fn(%{pid: pid}) ->
      :ok = PortMonitor.stop(pid)
    end)
    initial_state
  end

  @attrs [:id, :ip, :port, :type]

  defp add_monitor(state, %{addr: ip} = monitor)
      when is_map(state) do
    new_mon = monitor
              |> Map.from_struct
              |> Map.put_new(:ip, ip)
              |> Map.take(@attrs)
    add_monitor(state, new_mon)
  end

  defp add_monitor(%{monitors: monitors} = state,
       %{id: id, ip: ip, type: type} = monitor)
       when is_integer(id) and is_binary(ip) and type in @types do
    case monitors do
      %{^id => _monitor} ->
        state
      _ ->
        {:ok, pid} = start_monitor(monitor)
        put_in(state, [:monitors, id], Map.put(monitor, :pid, pid))
    end
  end

  defp start_monitor(%{ip: ip, port: port, type: "port"}) do
    {:ok, pid} = PortMonitor.start_link(ip, port)
    :ok = PortMonitor.start_monitor(pid)
    {:ok, pid}
  end

  defp start_monitor(%{ip: ip, type: "ping"}), do: PingMonitor.start_link(ip)

  defp stop_monitor(pid), do: GenServer.stop(pid)

  defp initial_state, do: %{monitors: %{}}
end
