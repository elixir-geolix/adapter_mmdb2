# Geolix Adapter: MMDB2

MMDB2 adapter for [`Geolix`](https://github.com/elixir-geolix/geolix).

## Package Setup

To use the Geolix MMDB2 Adapter with your projects, edit your `mix.exs` file and add the required dependencies:

```elixir
defp deps do
  [
    # ...
    {:geolix_adapter_mmdb2, "~> 0.5.0"},
    # ...
  ]
end
```

An appropriate version of `:geolix` is automatically selected by the adapter's dependency tree.

## Adapter Configuration

To start using the adapter with a compatible database you need to add the required configuration entry to your `:geolix` configuration:

```elixir
config :geolix,
  databases: [
    %{
      id: :geolite2_city,
      adapter: Geolix.Adapter.MMDB2,
      source: "/absolute/path/to/GeoLite2-City.mmdb"
    },
    %{
      id: :geolite2_country,
      adapter: Geolix.Adapter.MMDB2,
      source: "/absolute/path/to/GeoLite2-Country.mmdb"
    }
  ]
```

For more configuration details and options please refer to the inline documentation of the `Geolix.Adapter.MMDB2` module.

## Benchmark

A (minimal) benchmark script is included. Please refer to the Mixfile or `mix help` output for the name.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

License information about the supported [MaxMind GeoIP2 Country](https://www.maxmind.com/en/geoip2-country-database), [MaxMind GeoIP2 City](https://www.maxmind.com/en/geoip2-city) and [MaxMind GeoLite2](https://dev.maxmind.com/geoip/geoip2/geolite2/) databases can be found on their respective sites.
