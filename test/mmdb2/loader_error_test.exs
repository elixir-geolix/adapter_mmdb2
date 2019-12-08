defmodule Geolix.Adapter.MMDB2.LoaderErrorTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  alias Geolix.Adapter.MMDB2

  @fixture_path Path.expand("../fixtures", __DIR__)

  test "error if database contains no metadata" do
    db = %{id: :nometa_database, adapter: MMDB2, source: __ENV__.file}

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

  test "database with other error returned from reader" do
    db = %{
      id: :invalidnodecount_database,
      adapter: MMDB2,
      source: Path.join([@fixture_path, "GeoIP2-City-Test-Invalid-Node-Count.mmdb"])
    }

    log =
      capture_log(fn ->
        assert {:error, :invalid_node_count} = Geolix.load_database(db)
      end)

    assert log =~ "Failed to load database :invalidnodecount_database"
  end
end
