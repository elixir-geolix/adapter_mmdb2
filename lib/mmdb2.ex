defmodule Geolix.Adapter.MMDB2 do
  @moduledoc """
  Adapter for Geolix to work with MMDB2 databases.
  """

  alias Geolix.Adapter.MMDB2.Database
  alias Geolix.Adapter.MMDB2.Loader
  alias Geolix.Adapter.MMDB2.Storage

  @behaviour Geolix.Adapter

  @impl Geolix.Adapter
  def database_workers do
    import Supervisor.Spec

    [
      worker(Storage.Data, []),
      worker(Storage.Metadata, []),
      worker(Storage.Tree, [])
    ]
  end

  @impl Geolix.Adapter
  def load_database(database), do: Loader.load_database(database)

  @impl Geolix.Adapter
  def lookup(ip, opts) do
    case opts[:where] do
      nil -> nil
      where -> Database.lookup(ip, where, opts)
    end
  end

  @impl Geolix.Adapter
  def unload_database(database), do: Loader.unload_database(database)
end
