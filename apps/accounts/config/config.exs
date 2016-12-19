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
#     config :accounts, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:accounts, :key)
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
env_name = case Mix.env do
  :test -> :test
  :dev -> :development
  :prod -> :production
end

config :moebius, connection: [
  hostname: System.get_env("PGHOST"),
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  database: "useful_music_#{env_name}",
  pool_mod: DBConnection.Poolboy
],
scripts: "test/db"
