defmodule Geolix.Verification.Mixfile do
  use Mix.Project

  def project do
    [
      app: :geolix_verification,
      version: "0.0.1",
      elixir: "~> 1.5",
      deps: [{:geolix_adapter_mmdb2, path: "../../"}],
      deps_path: "../../deps",
      lockfile: "../../mix.lock"
    ]
  end
end
