defmodule UM.Web.Admin.Pieces do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, []

  def handle_request(%{path: []}, _env) do
    Raxx.Response.ok("All pieces TODO show UM100")
  end

  def handle_request(%{path: ["new"]}, _env) do
    Raxx.Response.ok(UM.Web.Admin.layout_page(new_page_content))
  end

  defp csrf_tag do
    "TODO create a real tag"
  end
end
