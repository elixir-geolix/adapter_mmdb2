defmodule Geolix.Adapter.MMDB2.MixProject do
  use Mix.Project

  @url_github "https://github.com/elixir-geolix/adapter_mmdb2"

  def project do
    [
      app: :geolix_adapter_mmdb2,
      name: "Geolix Adapter: MMDB2",
      version: "0.1.0-dev",
      elixir: "~> 1.5",
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
      extra_applications: [:logger],
      included_applications: [:mmdb2_decoder]
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
      {:dialyxir, "~> 1.0.0-rc", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:geolix, github: "elixir-geolix/geolix", ref: "ccd4a5d56b992ef65b9cebf0b25b12fb4529929b"},
      {:geolix_testdata, "~> 0.4.0", only: [:bench, :test], runtime: false},
      {:mmdb2_decoder, "~> 1.0"}
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
      plt_add_apps: [:inets, :mmdb2_decoder]
    ]
  end

  defp docs do
    [
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
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
