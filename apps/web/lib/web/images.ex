defmodule UM.Web.Images do
  require Raxx.Static
  @external_resource "./static/images"

  dir = "./static/images"
  Raxx.Static.serve_dir(dir)
end
