defmodule Geolix.Verification.Mixfile do
  use Mix.Project

  def project do
    [
      app: :geolix_verification,
      version: "0.0.1",
      elixir: "~> 1.5",
      deps: deps(),
      deps_path: "../../deps",
      lockfile: "../../mix.lock"
    ]
  end

  def application, do: [applications: [:geolix]]

  defp deps do
    [
      {:geolix, "~> 0.17"},
      {:geolix_adapter_mmdb2, path: "../../"},
      {:mmdb2_decoder, "~> 0.4.0", override: true}
    ]
  end
end
