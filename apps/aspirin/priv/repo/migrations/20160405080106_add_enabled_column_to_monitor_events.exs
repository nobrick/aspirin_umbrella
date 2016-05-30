defmodule Aspirin.Repo.Migrations.AddEnabledColumnToMonitorEvents do
  use Ecto.Migration

  def change do
    alter table(:monitor_events) do
      add :enabled, :boolean, default: true
    end
  end
end
