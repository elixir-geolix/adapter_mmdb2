defmodule Geolix.Adapter.MMDB2.Record.RepresentedCountry do
  @moduledoc """
  Record for `represented country` information.
  """

  alias Geolix.Adapter.MMDB2.Model

  defstruct [
    :geoname_id,
    :iso_code,
    :name,
    :names,
    :type,
    is_in_european_union: false
  ]

  @behaviour Model

  @impl Model
  def from(nil, _), do: nil
  def from(data, nil), do: struct(__MODULE__, data)

  def from(data, locale) do
    result = from(data, nil)
    result = Map.put(result, :name, result.names[locale])

    result
  end
end
