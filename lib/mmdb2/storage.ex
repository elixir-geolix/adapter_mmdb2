defmodule Geolix.Adapter.MMDB2.Storage do
  @moduledoc false

  use GenServer

  alias MMDB2Decoder.Metadata

  @type storage_entry :: {Metadata.t() | nil, binary | nil, binary | nil}

  @ets_table_opts [:named_table, :protected, :set, read_concurrency: true]

  @doc """
  Returns the worker specification for a database storage process.
  """
  @spec worker(atom) :: Supervisor.Spec.spec()
  def worker(database_id) do
    storage_id = storage_id(database_id)

    Supervisor.Spec.worker(__MODULE__, [storage_id], id: storage_id)
  end

  @doc false
  def start_link(storage_id) do
    GenServer.start_link(__MODULE__, storage_id, name: storage_id)
  end

  @doc false
  def init(storage_id) do
    :ok = create_ets_table(storage_id)

    {:ok, storage_id}
  end

  def handle_call({:set, entry}, _from, storage_id) do
    true = :ets.insert(storage_id, {:data, entry})

    {:reply, :ok, storage_id}
  end

  @doc """
  Fetches the data for a database.
  """
  @spec get(atom) :: storage_entry | nil
  def get(database_id) do
    storage_id = storage_id(database_id)

    case :ets.info(storage_id) do
      :undefined ->
        nil

      _ ->
        case :ets.lookup(storage_id, :data) do
          [{:data, entry}] -> entry
          _ -> nil
        end
    end
  end

  @doc """
  Stores the data for a database.
  """
  @spec set(atom, storage_entry) :: :ok
  def set(database_id, entry) do
    database_id
    |> storage_id()
    |> GenServer.call({:set, entry})
  end

  defp create_ets_table(storage_id) do
    case :ets.info(storage_id) do
      :undefined ->
        _ = :ets.new(storage_id, @ets_table_opts)
        :ok

      _ ->
        :ok
    end
  end

  defp storage_id(database_id), do: :"geolix_mmdb2_storage_#{database_id}"
end
