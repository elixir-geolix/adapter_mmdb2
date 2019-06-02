defmodule Geolix.Adapter.MMDB2.Storage.Tree do
  @moduledoc false

  use Agent

  @doc false
  @spec start_link(map) :: Agent.on_start()
  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  @doc """
  Fetches the tree for a database.
  """
  @spec get(atom) :: binary | nil
  def get(database) do
    Agent.get(__MODULE__, &Map.get(&1, database, nil))
  end

  @doc """
  Stores the tree for a specific database.
  """
  @spec set(atom, binary | nil) :: :ok
  def set(database, tree) do
    Agent.update(__MODULE__, &Map.put(&1, database, tree))
  end
end
