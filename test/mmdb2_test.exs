defmodule Geolix.Adapter.MMDB2Test do
  use ExUnit.Case, async: true

  alias Geolix.Adapter.MMDB2.Result.City
  alias MMDB2Decoder.Metadata

  test "result type" do
    ip = "81.2.69.160"
    where = :fixture_city

    refute Map.get(Geolix.lookup(ip, as: :raw, where: where), :__struct__)

    assert %City{} = Geolix.lookup(ip, as: :struct, where: where)
  end

  test "metadata access" do
    assert %Metadata{} = Geolix.metadata(where: :fixture_city)
  end

  test "custom mmdb2 decoder options" do
    ip = {1, 1, 1, 1}

    assert %{ip_address: ^ip, type: "test"} = Geolix.lookup(ip, as: :raw, where: :testdata_plain)

    assert %{"ip_address" => ^ip, "type" => "test"} =
             Geolix.lookup(ip,
               as: :raw,
               where: :testdata_plain,
               mmdb2_decoder_options: %{keys: :strings}
             )
  end
end
