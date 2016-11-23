defmodule UM.Web.Stylesheets do
  require Raxx.Static
  @external_resource "./static/stylesheets"

  dir = "./static/stylesheets"
  Raxx.Static.serve_dir(dir)
end
