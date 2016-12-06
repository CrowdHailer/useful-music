defmodule UM.Catalogue.Mixfile do
  use Mix.Project

  def project do
    [app: :catalogue,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :moebius, :arc],
      mod: {UM.Catalogue, []}]
  end

  defp deps do
    [
      {:arc, "~> 0.6.0-rc3"},
      {:moebius, "~> 2.0.0"}
    ]
  end
end
