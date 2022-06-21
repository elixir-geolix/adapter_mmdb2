defmodule Geolix.Adapter.MMDB2.Loader do
  @moduledoc false

  require Logger

  alias Geolix.Adapter.MMDB2
  alias Geolix.Adapter.MMDB2.Reader
  alias Geolix.Adapter.MMDB2.Storage

  @doc """
  Loads a database into storage.

  Requires the parameter `:source` as the location of the database. Can access
  the system environment by receiving a `{:system, "env_var_name"}` tuple.

  Using `{:system, "env_var_name", "/path/to/default.mmdb2"}` you can define
  a fallback value to be used if the environment variable is not set.
  """
  @spec load_database(MMDB2.database()) :: :ok | {:error, term}
  def load_database(%{source: {:system, var, default}} = database) do
    database
    |> Map.put(:source, System.get_env(var) || default)
    |> load_database()
  end

  def load_database(%{source: {:system, var}} = database) do
    database
    |> Map.put(:source, System.get_env(var))
    |> load_database()
  end

  def load_database(%{source: source} = database) do
    source
    |> Reader.read_database()
    |> store_data(database)
  end

  @doc """
  Removes a database from storage.
  """
  @spec unload_database(MMDB2.database()) :: :ok
  def unload_database(database), do: store_data({:ok, nil, nil, nil}, database)

  defp store_data({:error, :enoent} = error, %{id: id, source: source}) do
    _ = Logger.info("Source for database #{inspect(id)} not found: #{inspect(source)}")

    error
  end

  defp store_data({:error, :no_metadata} = error, %{id: id}) do
    _ = Logger.info("Failed to read metadata for database #{inspect(id)}")

    error
  end

  defp store_data({:error, {:remote, reason}} = error, %{id: id}) do
    _ = Logger.info("Failed to read remote for database #{inspect(id)}: #{inspect(reason)}")

    error
  end

  defp store_data({:error, reason} = error, %{id: id}) do
    _ = Logger.info("Failed to load database #{inspect(id)}: #{inspect(reason)}")

    error
  end

  defp store_data({:ok, meta, tree, data}, %{id: id} = database) do
    Storage.adapter(database).set(id, {meta, tree, data})
  end
end
