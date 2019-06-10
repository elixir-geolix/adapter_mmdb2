defmodule Geolix.Adapter.MMDB2 do
  @moduledoc """
  Adapter for Geolix to work with MMDB2 databases.

  ## Adapter Configuration

  To start using the adapter with a compatible database you need to add the
  required configuration entry to your `:geolix` configuration:

      config :geolix,
        databases: [
          %{
            id: :my_mmdb_database,
            adapter: Geolix.Adapter.MMDB2,
            source: "/absolute/path/to/my/database.mmdb"
          }
        ]
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
  def lookup(ip, opts), do: Database.lookup(ip, opts)

  @impl Geolix.Adapter
  def unload_database(database), do: Loader.unload_database(database)
end
