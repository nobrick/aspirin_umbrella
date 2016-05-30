defmodule Aspirin.StatusChannel do
  use Phoenix.Channel
  import Aspirin.MonitorManager, only: [sync_repo: 1]
  alias Aspirin.Repo
  alias Aspirin.MonitorEvent

  def join("status:all", _msg, socket) do
    {:ok, socket}
  end

  def join("status" <> _sub, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("switch:enabled",
      %{"event_id" => id, "enabled" => enabled} = params, socket) do
    event = Repo.get!(MonitorEvent, id)
    if event.enabled != enabled do
      MonitorEvent.changeset(event, %{enabled: enabled})
      |> Repo.update
      |> case do
      {:ok, monitor_event} ->
        sync_repo(Aspirin.MonitorManager)
        broadcast!(socket, "switch:enabled", params)
      {:error, changeset} ->
        nil
      end
    end
    {:noreply, socket}
  end
end
