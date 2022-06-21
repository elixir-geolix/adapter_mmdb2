defmodule Geolix.Adapter.MMDB2.Database do
  @moduledoc false

  alias Geolix.Adapter.MMDB2
  alias Geolix.Adapter.MMDB2.Result
  alias Geolix.Adapter.MMDB2.Storage
  alias MMDB2Decoder.Metadata

  @mmdb2_opts %{double_precision: 8, float_precision: 4, map_keys: :atoms}

  @doc """
  Performs a lookup in a loaded database.
  """
  @spec lookup(:inet.ip_address(), Keyword.t(), MMDB2.database()) :: map | nil
  def lookup(ip, opts, %{id: id} = database) do
    with {%Metadata{} = meta, tree, data} when is_binary(tree) and is_binary(data) <-
           Storage.adapter(database).get(id),
         mmdb2_opts <- mmdb2_opts(opts, database),
         {:ok, result} when is_map(result) <-
           MMDB2Decoder.lookup(ip, meta, tree, data, mmdb2_opts),
         result_as <- result_as(opts, database),
         result_ip_key <- result_ip_key(mmdb2_opts) do
      result
      |> Map.put(result_ip_key, ip)
      |> maybe_to_struct(result_as, meta, opts)
    else
      _ -> nil
    end
  end

  @doc """
  Returns the metadata for a loaded database.
  """
  @spec metadata(MMDB2.database()) :: Metadata.t() | nil
  def metadata(%{id: id} = database) do
    case Storage.adapter(database).get(id) do
      {%Metadata{} = meta, _, _} -> meta
      _ -> nil
    end
  end

  defp maybe_to_struct(result, :raw, _, _), do: result

  defp maybe_to_struct(result, :struct, %{database_type: type}, opts) do
    locale = Keyword.get(opts, :locale, :en)

    Result.to_struct(type, result, locale)
  end

  defp mmdb2_opts(opts, database) do
    opts[:mmdb2_decoder_options] || database[:mmdb2_decoder_options] || @mmdb2_opts
  end

  defp result_as(opts, database) do
    opts[:as] || database[:result_as] || :struct
  end

  defp result_ip_key(%{map_keys: :atoms}), do: :ip_address
  defp result_ip_key(%{map_keys: :atoms!}), do: :ip_address
  defp result_ip_key(_), do: "ip_address"
end
