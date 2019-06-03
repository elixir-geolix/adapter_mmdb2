defmodule Geolix.Adapter.MMDB2.Record.Postal do
  @moduledoc """
  Record for `postal` information.
  """

  alias Geolix.Adapter.MMDB2.Model

  defstruct [
    :code
  ]

  @behaviour Model

  @impl Model
  def from(nil, _), do: nil
  def from(data, _), do: struct(__MODULE__, data)
end
