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

  ## Database Configuration

  In order to work this adapter requires a `:source` configuration value to
  point to a valid MMDB2 format database.

  ### Compressed Databases

  Some limited support is built in to allow working with compressed databases
  if the filename matches one of the following patterns:

  - `*.gz` - It is expected to be a `gzip` compressed file
  - `*.tar` - It is expected to be a tarball and the first file in the archive ending in `.mmdb` will be loaded.
  - `*.tar.gz` - Combination of the above
  """

  alias Geolix.Adapter.MMDB2.Database
  alias Geolix.Adapter.MMDB2.Loader
  alias Geolix.Adapter.MMDB2.Storage

  @behaviour Geolix.Adapter

  @impl Geolix.Adapter
  def database_workers(%{id: database_id}), do: [Storage.worker(database_id)]

  @impl Geolix.Adapter
  def load_database(database), do: Loader.load_database(database)

  @impl Geolix.Adapter
  def lookup(ip, opts, database), do: Database.lookup(ip, opts, database)

  @impl Geolix.Adapter
  def unload_database(database), do: Loader.unload_database(database)
end
