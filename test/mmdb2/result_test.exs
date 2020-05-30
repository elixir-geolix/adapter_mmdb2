defmodule Geolix.Adapter.MMDB2.ResultTest do
  use ExUnit.Case, async: true

  alias Geolix.Adapter.MMDB2.Result

  test "unknown type is unmodified" do
    assert %{foo: :bar} = Result.to_struct("invalid-type", %{foo: :bar}, nil)
  end

  test "type to struct mapping" do
    assert %Result.City{} = Result.to_struct("GeoIP2-City", %{}, nil)
    assert %Result.City{} = Result.to_struct("GeoLite2-City", %{}, nil)
    assert %Result.Country{} = Result.to_struct("GeoIP2-Country", %{}, nil)
    assert %Result.Country{} = Result.to_struct("GeoLite2-Country", %{}, nil)
  end

  test "type to flat struct mapping" do
    assert %Result.AnonymousIP{} = Result.to_struct("GeoIP2-Anonymous-IP", %{}, nil)
    assert %Result.ConnectionType{} = Result.to_struct("GeoIP2-Connection-Type", %{}, nil)
    assert %Result.Domain{} = Result.to_struct("GeoIP2-Domain", %{}, nil)
    assert %Result.ISP{} = Result.to_struct("GeoIP2-ISP", %{}, nil)
  end
end
