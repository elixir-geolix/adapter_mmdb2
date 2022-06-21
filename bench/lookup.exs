:ok =
  Geolix.load_database(%{
    id: :benchmark_ets,
    adapter: Geolix.Adapter.MMDB2,
    source: Geolix.TestData.file(:mmdb2, "Benchmark.mmdb"),
    storage: Geolix.Adpater.MMDB2.Storage.ETS
  })

:ok =
  Geolix.load_database(%{
    id: :benchmark_pt,
    adapter: Geolix.Adapter.MMDB2,
    source: Geolix.TestData.file(:mmdb2, "Benchmark.mmdb"),
    storage: Geolix.Adpater.MMDB2.Storage.PersistentTerm
  })

{:ok, lookup_ipv4} = :inet.parse_address('1.1.1.1')
{:ok, lookup_ipv4_in_ipv6} = :inet.parse_address('::1.1.1.1')

Benchee.run(
  %{
    "IPv4 in IPV6 lookup (ETS)" => fn ->
      Geolix.lookup(lookup_ipv4_in_ipv6, where: :benchmark_ets)
    end,
    "IPv4 in IPV6 lookup (PersistentTerm)" => fn ->
      Geolix.lookup(lookup_ipv4_in_ipv6, where: :benchmark_pt)
    end,
    "IPv4 lookup (ETS)" => fn ->
      Geolix.lookup(lookup_ipv4, where: :benchmark_ets)
    end,
    "IPv4 lookup (PersistentTerm)" => fn ->
      Geolix.lookup(lookup_ipv4, where: :benchmark_pt)
    end
  },
  formatters: [{Benchee.Formatters.Console, comparison: false}],
  parallel: System.schedulers_online() * 4,
  warmup: 1,
  time: 5,
  memory_time: 2,
  reduction_time: 2
)
