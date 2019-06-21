defmodule Geolix.Adapter.MMDB2.Reader do
  @moduledoc false

  @doc """
  Reads a database file and returns the data and metadata parts from it.
  """
  @spec read_database(String.t()) :: MMDB2Decoder.parse_result()
  def read_database("http" <> _ = filename) do
    {:ok, _} = Application.ensure_all_started(:inets)

    case :httpc.request(String.to_charlist(filename)) do
      {:ok, {{_, 200, _}, _, body}} ->
        body
        |> IO.iodata_to_binary()
        |> maybe_gunzip(filename)
        |> maybe_untar(filename)
        |> MMDB2Decoder.parse_database()

      {:error, err} ->
        {:error, {:remote, err}}
    end
  end

  def read_database(nil), do: {:error, :enoent}

  def read_database(filename) do
    case File.stat(filename) do
      {:ok, _} ->
        filename
        |> File.read!()
        |> maybe_gunzip(filename)
        |> maybe_untar(filename)
        |> MMDB2Decoder.parse_database()

      error ->
        error
    end
  end

  defp find_mmdb_contents([]), do: nil

  defp find_mmdb_contents([{file, contents} | files]) do
    if String.ends_with?(to_string(file), ".mmdb") do
      contents
    else
      find_mmdb_contents(files)
    end
  end

  defp maybe_untar(data, filename) do
    if String.ends_with?(filename, [".tar", ".tar.gz"]) do
      {:ok, files} = :erl_tar.extract({:binary, data}, [:memory])

      find_mmdb_contents(files)
    else
      data
    end
  end

  defp maybe_gunzip(data, filename) do
    if String.ends_with?(filename, ".gz") do
      :zlib.gunzip(data)
    else
      data
    end
  end
end
