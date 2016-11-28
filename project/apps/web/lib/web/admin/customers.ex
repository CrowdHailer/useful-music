defmodule UM.Web.Admin.Customers do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(_, _) do
    Raxx.Response.ok(UM.Web.Admin.layout_page(index_page_content(%{
      size: 10,
      previous: false,
      next: 2,
      last: 1,
      customers: []
      })))
  end

  def csrf_tag do
    "TODO"
  end
end
