defmodule Geolix.Adapter.MMDB2.Mixfile do
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
      {:benchee, "~> 0.13.0", only: :bench},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      {:geolix, "~> 0.17"},
      {:geolix_testdata, "~> 0.3.0", only: [:bench, :test]},
      {:hackney, "~> 1.0", only: :test},
      {:mmdb2_decoder, "~> 0.4.0", override: true}
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
