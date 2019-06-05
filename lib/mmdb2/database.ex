defmodule Geolix.Adapter.MMDB2.Database do
  @moduledoc false

  alias Geolix.Adapter.MMDB2.Result
  alias Geolix.Adapter.MMDB2.Storage

  @doc """
  Performs a lookup in a loaded database.
  """
  @spec lookup(tuple, atom, Keyword.t()) :: map | nil
  def lookup(ip, where, opts) do
    data = Storage.Data.get(where)
    meta = Storage.Metadata.get(where)
    tree = Storage.Tree.get(where)

    lookup(ip, data, meta, tree, opts)
  end

  defp lookup(_, nil, _, _, _), do: nil
  defp lookup(_, _, nil, _, _), do: nil
  defp lookup(_, _, _, nil, _), do: nil

  defp lookup(ip, data, meta, tree, opts) do
    case MMDB2Decoder.lookup(ip, meta, tree, data) do
      {:error, _} ->
        nil

      {:ok, nil} ->
        nil

      {:ok, result} ->
        result_as = Keyword.get(opts, :as, :struct)

        result
        |> Map.put(:ip_address, ip)
        |> maybe_to_struct(result_as, meta, opts)
    end
  end

  defp maybe_to_struct(result, :raw, _, _), do: result

  defp maybe_to_struct(result, :struct, %{database_type: type}, opts) do
    locale = Keyword.get(opts, :locale, :en)

    Result.to_struct(type, result, locale)
  end
end
