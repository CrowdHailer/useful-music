defmodule UM.Accounts.Mixfile do
  use Mix.Project

  def project do
    [app: :accounts,
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
     mod: {UM.Accounts, []}]
  end

  defp deps do
    [
      {:utils, in_umbrella: true},
      {:countries, github: "SebastianSzturo/countries"},
      {:comeonin, "~> 3.0"},
      {:moebius, "~> 2.0.0"}
    ]
  end
end
