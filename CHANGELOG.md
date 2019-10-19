# Changelog

## v0.2.0 (2019-10-19)

- Enhancements
    - Databases are now stored in ets tables instead of Agent processes

- Bug fixes
    - Receiving a non 200 response from a remote database will now log an error instead of crashing ([elixir-geolix/geolix#28](https://github.com/elixir-geolix/geolix/issues/28))

## v0.1.0 (2019-09-08)

- Initial separation from [:geolix](https://github.com/elixir-geolix/geolix)

- Enhancements
    - Database metadata is now available via `Geolix.metadata/0,1` ([#1](https://github.com/elixir-geolix/adapter_mmdb2/pull/1))
