defmodule Geolix.Adapter.MMDB2.Storage.PersistentTerm do
  @moduledoc false

  alias MMDB2Decoder.Metadata

  @type storage_entry :: {Metadata.t() | nil, binary | nil, binary | nil}

  @doc """
  Fetches the data for a database.
  """
  @spec get(atom) :: storage_entry | nil
  def get(database_id) do
    database_id
    |> storage_id()
    |> :persistent_term.get()
  end

  @doc """
  Stores the data for a database.
  """
  @spec set(atom, storage_entry) :: :ok
  def set(database_id, entry) do
    database_id
    |> storage_id()
    |> :persistent_term.put(entry)
  end

  defp storage_id(database_id), do: :"geolix_mmdb2_storage_#{database_id}"
end
