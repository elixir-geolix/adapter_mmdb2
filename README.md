# Geolix Adapter: MMDB2

MMDB2 adapter for [`Geolix`](https://github.com/elixir-geolix/geolix).

## Benchmark

A (minimal) benchmark script looking up a predefined ip address is included:

```shell
mix bench.lookup
```

By default the benchmark uses the `Benchmark.mmdb` database provided by `:geolix_testdata`. To use a different database pass it's path as the sole argument to the `mix bench.lookup` call.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
