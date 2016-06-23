defmodule Aspirin.DiagramTest do
  use Aspirin.ModelCase

  alias Aspirin.Diagram

  @valid_attrs %{body: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Diagram.changeset(%Diagram{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Diagram.changeset(%Diagram{}, @invalid_attrs)
    refute changeset.valid?
  end
end
