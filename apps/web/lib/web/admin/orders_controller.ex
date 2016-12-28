defmodule UM.Web.Admin.OrdersController do
  import UM.Web.ViewHelpers
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(request = %{path: [], method: :GET, query: query}, _) do
    page = UM.Web.requested_page(query)
    {:ok, page_of_orders} = UM.Sales.Orders.index(page)
    Raxx.Response.ok(index_page_content(page_of_orders))
  end
end
