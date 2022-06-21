defmodule Geolix.Adapter.MMDB2.Storage do
  @moduledoc false

  alias Geolix.Adapter.MMDB2.Storage.ETS
  alias Geolix.Adapter.MMDB2.Storage.PersistentTerm

  def adapter(%{storage: PersistentTerm}), do: PersistentTerm
  def adapter(_), do: ETS

  def workers(%{storage: PersistentTerm}), do: []
  def workers(%{id: database_id}), do: [ETS.child_spec(database_id)]
end
