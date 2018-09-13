defmodule Geolix.Verification.Mixfile do
  use Mix.Project

  def project do
    [
      app: :geolix_verification,
      version: "0.0.1",
      elixir: "~> 1.5",
      deps: deps(),
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      preferred_cli_env: ["geolix.verify": :test]
    ]
  end

  def application, do: [applications: [:geolix]]

  defp deps do
    [
      {:geolix, "~> 0.17", only: :test},
      {:geolix_adapter_mmdb2, path: "../../", only: :test}
    ]
  end
end
