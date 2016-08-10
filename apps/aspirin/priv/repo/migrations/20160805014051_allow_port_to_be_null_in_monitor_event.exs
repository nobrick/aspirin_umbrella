defmodule Aspirin.Repo.Migrations.AllowPortToBeNullInMonitorEvent do
  use Ecto.Migration

  def change do
    alter table(:monitor_events) do
      modify :port, :integer, null: true
    end
  end
end
