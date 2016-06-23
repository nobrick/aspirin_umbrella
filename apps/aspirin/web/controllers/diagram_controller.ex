defmodule Aspirin.DiagramController do
  use Aspirin.Web, :controller

  alias Aspirin.Diagram

  plug :scrub_params, "diagram" when action in [:create, :update]

  def index(conn, _params) do
    diagrams = Repo.all(Diagram)
    render(conn, "index.html", diagrams: diagrams)
  end

  def new(conn, _params) do
    changeset = Diagram.changeset(%Diagram{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"diagram" => diagram_params}) do
    changeset = Diagram.changeset(%Diagram{}, diagram_params)

    case Repo.insert(changeset) do
      {:ok, _diagram} ->
        conn
        |> put_flash(:info, "Diagram created successfully.")
        |> redirect(to: diagram_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    diagram = Repo.get!(Diagram, id)
    changeset = Diagram.changeset(diagram)
    render(conn, "show.html", diagram: diagram, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    diagram = Repo.get!(Diagram, id)
    changeset = Diagram.changeset(diagram)
    render(conn, "edit.html", diagram: diagram, changeset: changeset)
  end

  def update(conn, %{"id" => id, "diagram" => diagram_params}) do
    diagram = Repo.get!(Diagram, id)
    changeset = Diagram.changeset(diagram, diagram_params)

    case Repo.update(changeset) do
      {:ok, diagram} ->
        conn
        |> put_flash(:info, "Diagram updated successfully.")
        |> redirect(to: diagram_path(conn, :show, diagram))
      {:error, changeset} ->
        render(conn, "edit.html", diagram: diagram, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    diagram = Repo.get!(Diagram, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(diagram)

    conn
    |> put_flash(:info, "Diagram deleted successfully.")
    |> redirect(to: diagram_path(conn, :index))
  end
end
