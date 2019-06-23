defmodule Geolix.Adapter.MMDB2.Benchmark.Lookup do
  def run do
    :ok =
      Geolix.load_database(%{
        id: :benchmark,
        adapter: Geolix.Adapter.MMDB2,
        source: Geolix.TestData.file(:mmdb2, "Benchmark.mmdb")
      })

    {:ok, lookup_ipv4} = :inet.parse_address('1.1.1.1')
    {:ok, lookup_ipv4_in_ipv6} = :inet.parse_address('::1.1.1.1')

    Benchee.run(
      %{
        "IPv4 in IPV6 lookup" => fn ->
          Geolix.lookup(lookup_ipv4_in_ipv6, where: :benchmark)
        end,
        "IPv4 lookup" => fn ->
          Geolix.lookup(lookup_ipv4, where: :benchmark)
        end
      },
      formatters: [{Benchee.Formatters.Console, comparison: false}],
      warmup: 2,
      time: 10
    )
  end
end

Geolix.Adapter.MMDB2.Benchmark.Lookup.run()
