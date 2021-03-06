defmodule Aspirin.MonitorEvent do
  use Aspirin.Web, :model

  schema "monitor_events" do
    field :addr, :string
    field :port, :integer
    field :name, :string
    field :type, :string, default: "ping"
    field :enabled, :boolean, default: true

    timestamps
  end

  @required_fields ~w(addr name type)
  @optional_fields ~w(port enabled)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:type, ~w(port ping))
    |> unique_constraint(:name)
    |> changeset_by_type
  end

  defp changeset_by_type(model) when not is_tuple(model) do
    {_from, type} = fetch_field(model, :type)
    changeset_by_type({model, type})
  end

  defp changeset_by_type({model, "port"}) do
    model
    |> validate_required(:port)
    |> validate_number(:port, greater_than: 0, less_than: 65536)
  end

  defp changeset_by_type({model, "ping"}) do
    put_change(model, :port, nil)
  end

  def by_name(query) do
    from m in query, order_by: m.name
  end

  def enabled(query) do
    from m in query, where: m.enabled == true
  end
end
