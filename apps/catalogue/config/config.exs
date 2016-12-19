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
#     config :catalogue, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:catalogue, :key)
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


config :arc,
  bucket: {:system, "S3_BUCKET_NAME"},
  # access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}],
  # secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}],
  asset_host: "https://s3-us-west-2.amazonaws.com/useful-music-tmp"

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  s3: [
    scheme: "https://",
    host: "s3-us-west-2.amazonaws.com",
    region: "us-west-2"
  ]

config :ex_aws, debug_requests: true
