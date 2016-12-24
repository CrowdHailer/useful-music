defmodule UM.Web.Mixfile do
  use Mix.Project

  def project do
    [app: :web,
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
    [applications: [:logger, :moebius, :catalogue, :accounts, :bugsnag],
     mod: {UM.Web, []}]
  end

  defp deps do
    [
      {:catalogue, in_umbrella: true},
      {:accounts, in_umbrella: true},
      {:utils, in_umbrella: true},
      {:ace, "~> 0.7.0"},
      {:bugsnag, "~> 1.3.2"},
      {:bamboo, "~> 0.7"},
      {:raxx, "~> 0.8.0"},
      {:moebius, "~> 2.0.0"},
      {:poison, "~> 2.0.1"},
      {:plug, "~> 1.2.2"} # DEBT remove; currently used for query strings etc
    ]
  end
end
