defmodule Geolix.Adapter.MMDB2TestHelpers.FixtureDownload do
  @moduledoc false

  alias Geolix.Adapter.MMDB2TestHelpers.FixtureList
  alias Geolix.TestData.MMDB2Fixture

  @doc """
  Downloads all fixture files.
  """
  def run, do: Enum.each(FixtureList.get(), &download/1)

  defp download({_name, filename}) do
    path = Path.join([__DIR__, "../fixtures"])
    local = Path.join([path, filename])

    if not File.regular?(local) do
      Mix.shell().info([:yellow, "Downloading fixture database: #{filename}"])
      MMDB2Fixture.download(filename, path)
    end
  end
end
