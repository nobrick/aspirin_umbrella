defmodule Aspirin.MonitorEventTest do
  use Aspirin.ModelCase

  alias Aspirin.MonitorEvent

  @valid_attrs %{addr: "192.168.1.1", name: "content", port: 80, type: "port"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MonitorEvent.changeset(%MonitorEvent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MonitorEvent.changeset(%MonitorEvent{}, @invalid_attrs)
    refute changeset.valid?
  end
end
