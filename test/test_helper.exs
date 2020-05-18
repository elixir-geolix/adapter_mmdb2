alias Geolix.Adapter.MMDB2
alias Geolix.Adapter.MMDB2TestHelpers.Fixture

Fixture.download()

Fixture.list()
|> Enum.map(fn
  {id, filename, :autoload} ->
    %{id: id, adapter: MMDB2, source: Path.join(Fixture.path(), filename)}

  _ ->
    nil
end)
|> Enum.reject(&(&1 == nil))
|> Enum.each(&Geolix.load_database/1)

[
  %{
    id: :testdata_gz,
    adapter: MMDB2,
    source: Path.join(Geolix.TestData.dir(:mmdb2), "Geolix.mmdb.gz")
  },
  %{
    id: :testdata_plain,
    adapter: MMDB2,
    source: Path.join(Geolix.TestData.dir(:mmdb2), "Geolix.mmdb")
  },
  %{
    id: :testdata_tar,
    adapter: MMDB2,
    source: Path.join(Geolix.TestData.dir(:mmdb2), "Geolix.mmdb.tar")
  },
  %{
    id: :testdata_targz,
    adapter: MMDB2,
    source: Path.join(Geolix.TestData.dir(:mmdb2), "Geolix.mmdb.tar.gz")
  }
]
|> Enum.each(&Geolix.load_database/1)

ExUnit.start()
