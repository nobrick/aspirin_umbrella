defmodule Aspirin.MonitorEventTest do
  use Aspirin.ModelCase

  alias Aspirin.MonitorEvent

  @valid_attrs %{addr: "some content", name: "some content", port: 42, type: "some content"}
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
