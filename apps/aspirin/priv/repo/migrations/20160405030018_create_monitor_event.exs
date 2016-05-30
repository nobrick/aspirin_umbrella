defmodule Aspirin.Repo.Migrations.CreateMonitorEvent do
  use Ecto.Migration

  def change do
    create table(:monitor_events) do
      add :addr, :string
      add :port, :integer
      add :name, :string
      add :type, :string

      timestamps
    end

  end
end
