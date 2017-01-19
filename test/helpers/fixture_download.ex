defmodule Geolix.Adapter.MMDB2TestHelpers.FixtureDownload do
  @moduledoc false

  alias Geolix.Adapter.MMDB2TestHelpers.FixtureList

  @doc """
  Downloads all fixture files.
  """
  def run() do
    Enum.each(FixtureList.get(), &download/1)
  end

  defp download({ _name, filename, remote }) do
    local = local(filename)

    if not File.regular?(local) do
      Mix.shell.info [ :yellow, "Downloading fixture database: #{ filename }" ]

      download_fixture(remote, local)
    end
  end

  if Version.match?(System.version, ">= 1.1.0") do
    defp download_fixture(remote, local) do
      { :ok, content } = Mix.Utils.read_path(remote)

      File.write! local, content
    end
  else
    defp download_fixture(remote, local) do
      File.write! local, Mix.Utils.read_path!(remote)
    end
  end

  defp local(filename) do
    [ __DIR__, "../fixtures/", filename ]
    |> Path.join()
    |> Path.expand()
  end
end
