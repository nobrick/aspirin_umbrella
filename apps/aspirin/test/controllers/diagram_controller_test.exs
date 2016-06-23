defmodule Aspirin.DiagramControllerTest do
  use Aspirin.ConnCase

  alias Aspirin.Diagram
  @valid_attrs %{body: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, diagram_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing diagrams"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, diagram_path(conn, :new)
    assert html_response(conn, 200) =~ "New diagram"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, diagram_path(conn, :create), diagram: @valid_attrs
    assert redirected_to(conn) == diagram_path(conn, :index)
    assert Repo.get_by(Diagram, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, diagram_path(conn, :create), diagram: @invalid_attrs
    assert html_response(conn, 200) =~ "New diagram"
  end

  test "shows chosen resource", %{conn: conn} do
    diagram = Repo.insert! %Diagram{}
    conn = get conn, diagram_path(conn, :show, diagram)
    assert html_response(conn, 200) =~ "Show diagram"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, diagram_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    diagram = Repo.insert! %Diagram{}
    conn = get conn, diagram_path(conn, :edit, diagram)
    assert html_response(conn, 200) =~ "Edit diagram"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    diagram = Repo.insert! %Diagram{}
    conn = put conn, diagram_path(conn, :update, diagram), diagram: @valid_attrs
    assert redirected_to(conn) == diagram_path(conn, :show, diagram)
    assert Repo.get_by(Diagram, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    diagram = Repo.insert! %Diagram{}
    conn = put conn, diagram_path(conn, :update, diagram), diagram: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit diagram"
  end

  test "deletes chosen resource", %{conn: conn} do
    diagram = Repo.insert! %Diagram{}
    conn = delete conn, diagram_path(conn, :delete, diagram)
    assert redirected_to(conn) == diagram_path(conn, :index)
    refute Repo.get(Diagram, diagram.id)
  end
end
