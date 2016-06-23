defmodule Aspirin.Repo.Migrations.CreateDiagram do
  use Ecto.Migration

  def change do
    create table(:diagrams) do
      add :name, :string
      add :body, :text

      timestamps
    end

  end
end
