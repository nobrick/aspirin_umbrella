defmodule Aspirin.MonitorEvent do
  use Aspirin.Web, :model

  schema "monitor_events" do
    field :addr, :string
    field :port, :integer
    field :name, :string
    field :type, :string, default: "port"
    field :enabled, :boolean, default: true

    timestamps
  end

  @required_fields ~w(addr port name type)
  @optional_fields ~w(enabled)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:type, ~w(port))
    |> validate_number(:port, greater_than: 0, less_than: 65536)
    |> unique_constraint(:name)
  end

  def by_name(query) do
    from m in query, order_by: m.name
  end

  def enabled(query) do
    from m in query, where: m.enabled == true
  end
end
