Code.require_file("fixtures/list.exs", __DIR__)
Code.require_file("fixtures/download.exs", __DIR__)

alias Geolix.Adapter.MMDB2
alias Geolix.Adapter.MMDB2TestFixtures


{ :ok, _ } = Application.ensure_all_started(:geolix)
:ok        = MMDB2TestFixtures.Download.run()

databases = Enum.map MMDB2TestFixtures.List.get(), fn ({ id, filename, _remote }) ->
  source =
    [ __DIR__, "fixtures", filename ]
    |> Path.join()
    |> Path.expand()

  %{ id: id, adapter: MMDB2, source: source }
end

Application.put_env(:geolix, :databases, databases)
Enum.each(databases, &Geolix.load_database/1)


ExUnit.start()
