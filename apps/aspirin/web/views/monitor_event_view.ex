defmodule Aspirin.MonitorEventView do
  use Aspirin.Web, :view

  def css_identity(%{type: type, addr: addr, port: port} = _event) do
    css_identity(type, addr, port)
  end

  def css_identity(type, addr, port) do
    String.replace("#{type}-#{addr}-#{port}", ".", "_")
  end

  def switch_id(event) do
    "enabled-switch-#{event.id}"
  end

  def switch_checked_flag(event) do
    if event.enabled, do: "checked", else: ""
  end
end
