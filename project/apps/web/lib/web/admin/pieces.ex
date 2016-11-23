defmodule UM.Web.Admin.Pieces do
  def handle_request(%{path: []}, _env) do
    Raxx.Response.ok("All pieces")
  end
end
