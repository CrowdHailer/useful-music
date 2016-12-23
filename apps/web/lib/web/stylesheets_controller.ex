defmodule UM.Web.StylesheetsController do
  require Raxx.Static
  # Ensures recompilation of module when depended files change.
  # DEBT see if can be moved to the `serve_dir` macro.
  @external_resource "./static/stylesheets"

  dir = "./static/stylesheets"
  Raxx.Static.serve_dir(dir)
end
