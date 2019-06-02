defmodule Geolix.Adapter.MMDB2.Storage.Metadata do
  @moduledoc false

  use Agent

  alias MMDB2Decoder.Metadata

  @doc false
  @spec start_link(map) :: Agent.on_start()
  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  @doc """
  Fetches a metadata entry for a database.
  """
  @spec get(atom) :: Metadata.t() | nil
  def get(database) do
    Agent.get(__MODULE__, &Map.get(&1, database, nil))
  end

  @doc """
  Stores a set of metadata for a specific database.
  """
  @spec set(atom, Metadata.t() | nil) :: :ok
  def set(database, metadata) do
    Agent.update(__MODULE__, &Map.put(&1, database, metadata))
  end
end
