defmodule Aspirin.MonitorEventView do
  use Aspirin.Web, :view

  def css_identity(%{type: "port", addr: addr, port: port} = _event) do
    css_identity(:port, addr, port)
  end

  def css_identity(%{type: "ping", addr: addr} = _event) do
     css_identity(:ping, addr)
  end

  def css_identity(:port, addr, port) do
    "port-#{addr}-#{port}" |> format_addr
  end

  def css_identity(:ping, addr) do
    "ping-#{addr}" |> format_addr
  end

  defp format_addr(addr) do
    String.replace(addr, ".", "_")
  end

  def switch_id(event) do
    "enabled-switch-#{event.id}"
  end

  def switch_checked_flag(event) do
    if event.enabled, do: "checked", else: ""
  end

  def event_type(changeset) do
    {_from, type} = Ecto.Changeset.fetch_field(changeset, :type)
    type
  end
end
