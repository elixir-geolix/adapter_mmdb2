defmodule Geolix.Adapter.MMDB2.MixProject do
  use Mix.Project

  @url_github "https://github.com/elixir-geolix/adapter_mmdb2"

  def project do
    [
      app: :geolix_adapter_mmdb2,
      name: "Geolix Adapter: MMDB2",
      version: "0.6.0-dev",
      elixir: "~> 1.7",
      aliases: aliases(),
      deps: deps(),
      description: "MMDB2 adapter for Geolix",
      dialyzer: dialyzer(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      preferred_cli_env: [
        "bench.lookup": :bench,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:inets, :logger, :ssl]
    ]
  end

  defp aliases() do
    [
      "bench.lookup": ["run bench/lookup.exs"]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :bench, runtime: false},
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13.0", only: :test, runtime: false},
      {:geolix, github: "elixir-geolix/geolix", rev: "39d8d2067d0d44d7f44a8034f37c89928ac1cef6"},
      {:geolix_testdata, "~> 0.5.1", only: [:bench, :test], runtime: false},
      {:mmdb2_decoder, "~> 3.0"}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :race_conditions,
        :underspecs,
        :unmatched_returns
      ],
      plt_add_apps: [:inets]
    ]
  end

  defp docs do
    [
      groups_for_modules: [
        "Result Structs (Databases)": [
          Geolix.Adapter.MMDB2.Result.ASN,
          Geolix.Adapter.MMDB2.Result.AnonymousIP,
          Geolix.Adapter.MMDB2.Result.City,
          Geolix.Adapter.MMDB2.Result.ConnectionType,
          Geolix.Adapter.MMDB2.Result.Country,
          Geolix.Adapter.MMDB2.Result.Domain,
          Geolix.Adapter.MMDB2.Result.Enterprise,
          Geolix.Adapter.MMDB2.Result.ISP
        ],
        "Result Structs (Records)": [
          Geolix.Adapter.MMDB2.Record.City,
          Geolix.Adapter.MMDB2.Record.Continent,
          Geolix.Adapter.MMDB2.Record.Country,
          Geolix.Adapter.MMDB2.Record.EnterpriseCity,
          Geolix.Adapter.MMDB2.Record.EnterpriseCountry,
          Geolix.Adapter.MMDB2.Record.EnterprisePostal,
          Geolix.Adapter.MMDB2.Record.EnterpriseSubdivision,
          Geolix.Adapter.MMDB2.Record.Location,
          Geolix.Adapter.MMDB2.Record.Postal,
          Geolix.Adapter.MMDB2.Record.RepresentedCountry,
          Geolix.Adapter.MMDB2.Record.Subdivision
        ]
      ],
      main: "Geolix.Adapter.MMDB2",
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github}
    }
  end
end
