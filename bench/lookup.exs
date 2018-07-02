defmodule Geolix.Adapter.MMDB2.Benchmark.Lookup do
  def run() do
    database =
      [Geolix.TestData.dir(:mmdb2), "Benchmark.mmdb"]
      |> Path.join()
      |> Path.expand()

    case File.exists?(database) do
      true ->
        {:ok, _} = Application.ensure_all_started(:geolix)

        :ok =
          Geolix.load_database(%{
            id: :benchmark,
            adapter: Geolix.Adapter.MMDB2,
            source: database
          })

        run_benchmark()

      false ->
        IO.warn("Expected database not found at #{database}")
    end
  end

  defp run_benchmark() do
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
      formatter_options: %{console: %{comparison: false}},
      warmup: 2,
      time: 10
    )
  end
end

Geolix.Adapter.MMDB2.Benchmark.Lookup.run()
