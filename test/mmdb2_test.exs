defmodule Geolix.Adapter.MMDB2Test do
  use ExUnit.Case, async: true

  test "result type" do
    ip = "81.2.69.160"
    where = :fixture_city

    refute Map.get(Geolix.lookup(ip, as: :raw, where: where), :__struct__)

    assert %Geolix.Result.City{} = Geolix.lookup(ip, as: :struct, where: where)
  end
end
