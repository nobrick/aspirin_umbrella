defmodule Aspirin.MonitorEvent.EnabledStateController do
  use Aspirin.Web, :controller
  alias Aspirin.MonitorEvent

  def create(conn, %{"id" => id, "monitor_event" => monitor_event_params}) do
  end

  def delete(conn, %{"id" => id}) do
  end
end
