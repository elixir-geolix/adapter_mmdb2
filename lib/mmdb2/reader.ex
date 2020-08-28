defmodule Geolix.Adapter.MMDB2.Reader do
  @moduledoc false

  @doc """
  Reads a database file and returns the data and metadata parts from it.
  """
  @spec read_database(String.t()) :: MMDB2Decoder.parse_result()
  def read_database("http" <> _ = url) do
    {:ok, _} = Application.ensure_all_started(:ssl)
    {:ok, _} = Application.ensure_all_started(:inets)

    filename = "/tmp/geolite_db"

    with {:ok, :saved_to_file} <-
           :httpc.request(:get, {String.to_charlist(url), []}, [],
             stream: String.to_charlist(filename)
           ),
         {:ok, data} <- File.read(filename) do
      result =
        data
        |> maybe_gunzip()
        |> maybe_untar()
        |> MMDB2Decoder.parse_database()

      File.rm(filename)

      result
    else
      {:error, err} ->
        {:error, {:remote, err}}

      {:ok, {{_, status, _}, _, _}} ->
        {:error, {:remote, {:status, status}}}
    end
  end

  def read_database(filename) do
    case File.stat(filename) do
      {:ok, _} ->
        filename
        |> File.read!()
        |> maybe_gunzip()
        |> maybe_untar()
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

  defp maybe_untar(data) do
    case :erl_tar.extract({:binary, data}, [:memory]) do
      {:ok, files} -> find_mmdb_contents(files)
      {:error, _} -> data
    end
  end

  defp maybe_gunzip(data) do
    :zlib.gunzip(data)
  rescue
    _ -> data
  end
end
