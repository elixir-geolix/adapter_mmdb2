defmodule Geolix.Adapter.MMDB2.Storage do
  @moduledoc false

  use Agent

  alias MMDB2Decoder.Metadata

  @type storage_entry :: {Metadata.t() | nil, binary | nil, binary | nil}

  @doc """
  Returns the worker specification for a database storage process.
  """
  @spec worker(atom) :: Supervisor.Spec.spec()
  def worker(database_id) do
    worker_id = worker_id(database_id)

    Supervisor.Spec.worker(__MODULE__, [worker_id], id: worker_id)
  end

  @doc false
  @spec start_link(atom) :: Agent.on_start()
  def start_link(worker_id) do
    Agent.start_link(fn -> nil end, name: worker_id)
  end

  @doc """
  Fetches the data for a database.
  """
  @spec get(atom) :: storage_entry | nil
  def get(database_id) do
    database_id
    |> worker_id()
    |> Agent.get(fn entry -> entry end)
  end

  @doc """
  Stores the data for a database.
  """
  @spec set(atom, storage_entry) :: :ok
  def set(database_id, entry) do
    database_id
    |> worker_id()
    |> Agent.update(fn _ -> entry end)
  end

  defp worker_id(database_id), do: :"geolix_mmdb2_storage_#{database_id}"
end
