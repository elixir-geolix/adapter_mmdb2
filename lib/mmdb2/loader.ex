defmodule Geolix.Adapter.MMDB2.Loader do
  @moduledoc false

  require Logger

  alias Geolix.Adapter.MMDB2.Reader
  alias Geolix.Adapter.MMDB2.Storage

  @doc """
  Implementation of `Geolix.Adapter.MMDB2.load_database/1`.

  Requires the parameter `:source` as the location of the database. Can access
  the system environment by receiving a `{ :system, "env_var_name" }` tuple.

  Using `{ :system, "env_var_name", "/path/to/default.mmdb2" }` you can define
  a fallback value to be used if the environment variable is not set.
  """
  @spec load_database(map) :: :ok | {:error, term}
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
  Implementation of `Geolix.Adapter.MMDB2.unload_database/1`.
  """
  def unload_database(%{id: id}), do: store_data({:ok, nil, nil, nil}, id)

  defp store_data({:error, :enoent} = error, %{id: id, source: source}) do
    _ =
      Logger.info(fn ->
        "Source for database #{inspect(id)} not found: #{inspect(source)}"
      end)

    error
  end

  defp store_data({:error, :no_metadata} = error, %{id: id}) do
    _ =
      Logger.info(fn ->
        "Failed to read metadata for database #{inspect(id)}"
      end)

    error
  end

  defp store_data({:error, {:remote, reason}} = error, %{id: id}) do
    _ =
      Logger.info(fn ->
        "Failed to read remote for database #{inspect(id)}: #{inspect(reason)}"
      end)

    error
  end

  defp store_data({:error, reason} = error, %{id: id}) do
    _ =
      Logger.info(fn ->
        "Failed to load database #{inspect(id)}: #{inspect(reason)}"
      end)

    error
  end

  defp store_data({:ok, meta, tree, data}, %{id: id}) do
    Storage.Data.set(id, data)
    Storage.Metadata.set(id, meta)
    Storage.Tree.set(id, tree)

    :ok
  end
end
