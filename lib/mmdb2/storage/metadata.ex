defmodule Geolix.Adapter.MMDB2.Storage.Metadata do
  @moduledoc false

  alias MMDB2Decoder.Metadata

  @doc """
  Starts the metadata agent.
  """
  @spec start_link() :: Agent.on_start()
  def start_link, do: Agent.start_link(fn -> %{} end, name: __MODULE__)

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
