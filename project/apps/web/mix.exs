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
    [applications: [:logger],
     mod: {UM.Web, []}]
  end

  defp deps do
    [
      {:ace, "~> 0.7.0"},
      {:raxx, "~> 0.4.3"},
      {:plug, "~> 1.2.2"} # TODO remove; currently used for query strings etc
    ]
  end
end
