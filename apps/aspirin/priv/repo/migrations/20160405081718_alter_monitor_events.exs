defmodule Aspirin.Repo.Migrations.AlterMonitorEvents do
  use Ecto.Migration

  def change do
    alter table(:monitor_events) do
      modify :addr, :string, null: false
      modify :port, :integer, null: false
      modify :name, :string, null: false
      modify :type, :string, default: "port", null: false
    end
    create index(:monitor_events, [:enabled])
    create unique_index(:monitor_events, [:name])
  end
end
