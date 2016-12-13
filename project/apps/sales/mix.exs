defmodule UM.Sales.Mixfile do
  use Mix.Project

  def project do
    [app: :sales,
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
    [applications: [:logger, :moebius],
     mod: {UM.Sales, []}]
  end

  defp deps do
    [
      {:moebius, "~> 2.0.0"},
      {:utils, in_umbrella: true},
    ]
  end
end
