defmodule Geolix.Adapter.MMDB2.Storage do
  @moduledoc false

  use Agent

  alias MMDB2Decoder.Metadata

  @type storage_entry :: {Metadata.t() | nil, binary | nil, binary | nil}

  @doc false
  @spec start_link(map) :: Agent.on_start()
  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  @doc """
  Fetches the data for a database.
  """
  @spec get(atom) :: storage_entry | nil
  def get(database) do
    Agent.get(__MODULE__, &Map.get(&1, database, nil))
  end

  @doc """
  Stores the data for a database.
  """
  @spec set(atom, storage_entry) :: :ok
  def set(database, entry) do
    Agent.update(__MODULE__, &Map.put(&1, database, entry))
  end
end
