defmodule Geolix.Adapter.MMDB2TestHelpers.Fixture do
  @moduledoc false

  alias Geolix.TestData.MMDB2Fixture

  @path Path.expand("../fixtures", __DIR__)
  @fixtures [
    {:fixture_anonymous, "GeoIP2-Anonymous-IP-Test.mmdb", :autoload},
    {:fixture_asn, "GeoLite2-ASN-Test.mmdb", :autoload},
    {:fixture_city, "GeoIP2-City-Test.mmdb", :autoload},
    {:fixture_connection, "GeoIP2-Connection-Type-Test.mmdb", :autoload},
    {:fixture_country, "GeoIP2-Country-Test.mmdb", :autoload},
    {:fixture_domain, "GeoIP2-Domain-Test.mmdb", :autoload},
    {:fixture_enterprise, "GeoIP2-Enterprise-Test.mmdb", :autoload},
    {:fixture_invalid_node_count, "GeoIP2-City-Test-Invalid-Node-Count.mmdb", :noload},
    {:fixture_isp, "GeoIP2-ISP-Test.mmdb", :autoload}
  ]

  def download do
    Enum.each(@fixtures, fn {_name, file, _load} ->
      MMDB2Fixture.download(file, @path)
    end)
  end

  def list, do: @fixtures
end
