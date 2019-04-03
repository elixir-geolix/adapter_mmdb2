defmodule Geolix.Adapter.MMDB2.Database.LoaderErrorTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  alias Geolix.Adapter.MMDB2

  @fixture_path Path.expand("../fixtures", __DIR__)

  test "error if database contains no metadata" do
    path = Path.join([@fixture_path, ".gitignore"])
    db = %{id: :nometa_database, adapter: MMDB2, source: path}

    log =
      capture_log(fn ->
        assert {:error, :no_metadata} == Geolix.load_database(db)
      end)

    assert log =~ "Failed to read metadata for database :nometa_database"
  end

  test "database with invalid filename (not found)" do
    db = %{id: :notfound_database, adapter: MMDB2, source: "invalid"}

    log =
      capture_log(fn ->
        assert {:error, :enoent} = Geolix.load_database(db)
      end)

    assert log =~ "Source for database :notfound_database not found"
  end

  test "database with invalid filename (remote not found)" do
    db = %{id: :notremote_database, adapter: MMDB2, source: "http://does.not.exist/"}

    log =
      capture_log(fn ->
        assert {:error, {:remote, {:failed_connect, _}}} = Geolix.load_database(db)
      end)

    assert log =~ "Failed to read remote for database :notremote_database"
  end
end
