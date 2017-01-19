alias Geolix.Adapter.MMDB2
alias Geolix.Adapter.MMDB2TestHelpers.FixtureDownload
alias Geolix.Adapter.MMDB2TestHelpers.FixtureList


{ :ok, _ } = Application.ensure_all_started(:geolix)
:ok        = FixtureDownload.run()

databases = Enum.map FixtureList.get(), fn ({ id, filename, _remote }) ->
  source =
    [ __DIR__, "fixtures", filename ]
    |> Path.join()
    |> Path.expand()

  %{ id: id, adapter: MMDB2, source: source }
end

Application.put_env(:geolix, :databases, databases)
Enum.each(databases, &Geolix.load_database/1)


ExUnit.start()
