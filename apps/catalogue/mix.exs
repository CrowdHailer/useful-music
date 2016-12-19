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
    [applications: [:logger, :moebius, :arc, :ex_aws, :hackney, :poison],
      mod: {UM.Catalogue, []}]
  end

  defp deps do
    [
      {:arc, "~> 0.6.0-rc3"},
      {:moebius, "~> 2.0.0"},

      # If using Amazon S3 (arc):
      ex_aws: "~> 1.0.0-rc3",
      hackney: "~> 1.5",
      poison: "~> 2.0",
      sweet_xml: "~> 0.5"
    ]
  end
end
