# Changelog

## v0.3.0-dev

- Bug fixes
    - `:mmdb2_decoder` has been moved from `:included_applications` to `:applications` to avoid potential problems with release tooling ([elixir-geolix/geolix#24](https://github.com/elixir-geolix/geolix/issues/24))

- Backwards incompatible changes
    - Minimum required elixir version is now `~> 1.7`
    - `:mmdb2_decoder` has been updated to `~> 2.0`
        - As a result the database descriptions in `MMDB2Decoder.Metadata` are now always a map with binary keys instead of atom keys

## v0.2.0 (2019-10-19)

- Enhancements
    - Databases are now stored in ets tables instead of Agent processes

- Bug fixes
    - Receiving a non 200 response from a remote database will now log an error instead of crashing ([elixir-geolix/geolix#28](https://github.com/elixir-geolix/geolix/issues/28))

## v0.1.0 (2019-09-08)

- Initial separation from [:geolix](https://github.com/elixir-geolix/geolix)

- Enhancements
    - Database metadata is now available via `Geolix.metadata/0,1` ([#1](https://github.com/elixir-geolix/adapter_mmdb2/pull/1))
