# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :web, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:web, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

# Need this for interop with ruby sequel
# TODO web should not need access to the database directly
# TODO only need to setup db config once
env_name = case Mix.env do
  :test -> :test
  :dev -> :development
  :prod -> :production
end

connection_config = case System.get_env("DATABASE_URL") do
  url when is_binary(url) ->
    [url: url]
  :nil ->
    [
      hostname: System.get_env("PGHOST"),
      username: System.get_env("PGUSER"),
      password: System.get_env("PGPASSWORD"),
      database: "useful_music_#{env_name}"
    ]
end

config :moebius, connection: connection_config ++ [
  pool_mod: DBConnection.Poolboy
],
scripts: "test/db"

config :bugsnag,
  api_key: System.get_env("BUGSNAG_API_KEY"),
  use_logger: true,
  release_stage: "elixir"
