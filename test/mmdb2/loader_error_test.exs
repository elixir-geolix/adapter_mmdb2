defmodule Geolix.Adapter.MMDB2.Database.LoaderErrorTest do
  use ExUnit.Case, async: true

  alias Geolix.Adapter.MMDB2

  @fixture_path Path.expand("../fixtures", __DIR__)

  test "error if database contains no metadata" do
    path = Path.join([@fixture_path, ".gitignore"])
    db = %{id: :invalid, adapter: MMDB2, source: path}

    assert {:error, :no_metadata} == Geolix.load_database(db)
  end

  test "database with invalid filename (not found)" do
    db = %{id: :unknown_database, adapter: MMDB2, source: "invalid"}

    assert {:error, :enoent} = Geolix.load_database(db)
  end

  test "database with invalid filename (remote not found)" do
    db = %{id: :unknown_database, adapter: MMDB2, source: "http://does.not.exist/"}
    err = Geolix.load_database(db)

    assert {:error, {:remote, {:failed_connect, _}}} = err
  end
end
