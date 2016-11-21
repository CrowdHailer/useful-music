defmodule UM.Web.Assets do
  require Raxx.Static

  dir = "./static"
  Raxx.Static.serve_dir(dir)
end
