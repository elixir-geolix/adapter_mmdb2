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

  ### MMDB2 Decoder Options

  If not configured or passed otherwise the following options are used for
  decoding:

      %{
        double_precision: 8,
        float_precision: 4,
        map_keys: :atoms
      }

  You can pass a custom option to the lookup request:

      iex(1)> mmdb2_opts = %{
      ......>   double_precision: 8,
      ......>   float_precision: 4,
      ......>   map_keys: :strings
      ......> }
      iex(2)> Geolix.lookup({1, 1, 1, 1}, mmdb2_decoder_options: mmdb2_opts)

  Or configure your values as the defaults if not passed:

      config :geolix,
        databases: [
          %{
            id: :my_mmdb_database,
            adapter: Geolix.Adapter.MMDB2,
            source: "/absolute/path/to/my/database.mmdb",
            mmdb2_decoder_options: %{
              double_precision: 8,
              float_precision: 4,
              map_keys: :strings
            }
          }
        ]

  ### Result Transformation

  By default a result is transformed to a struct matching your database type.

  This setting can be modified by passing an option to the lookup request:

      iex> Geolix.lookup({1, 1, 1, 1}, as: :raw)

  Or configure a default if not passed:

      config :geolix,
        databases: [
          %{
            id: :my_mmdb_database,
            adapter: Geolix.Adapter.MMDB2,
            source: "/absolute/path/to/my/database.mmdb",
            result_as: :raw
          }
        ]

  Possible options:

  - `:raw` - Return results as found in the database
  - `:struct` - Return values after transforming them to a result struct (default)

  Passing `as: :raw` skips the struct transformation and returns the value as
  read from your database. This option may be necessary if you have configured
  custom `:mmdb2_decoder_options`.
  """

  alias Geolix.Adapter.MMDB2.Database
  alias Geolix.Adapter.MMDB2.Loader
  alias Geolix.Adapter.MMDB2.Storage

  @typedoc """
  Extended base database type.
  """
  @type database :: %{
          required(:id) => atom,
          required(:adapter) => module,
          required(:source) => binary | {:system, binary} | {:system, binary, binary},
          optional(:init) => {module, atom} | {module, atom, [term]},
          optional(:mmdb2_decoder_options) => MMDB2Decoder.decode_options(),
          optional(:result_as) => :raw | :struct
        }

  @behaviour Geolix.Adapter

  @impl Geolix.Adapter
  def database_workers(database), do: Storage.workers(database)

  @impl Geolix.Adapter
  def load_database(database), do: Loader.load_database(database)

  @impl Geolix.Adapter
  def lookup(ip, opts, database), do: Database.lookup(ip, opts, database)

  @impl Geolix.Adapter
  def metadata(database), do: Database.metadata(database)

  @impl Geolix.Adapter
  def unload_database(database), do: Loader.unload_database(database)
end
