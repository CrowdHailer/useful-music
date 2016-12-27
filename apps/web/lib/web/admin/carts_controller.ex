defmodule UM.Web.Admin.CartsController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(%{path: [], method: :GET}, _) do
    # TODO fix pagination
    {:ok, page_of_carts} = UM.Sales.CartsRepo.index(%{page_size: 15, page_number: 1})
    Raxx.Response.ok(index_page_content(page_of_carts))
  end

  defp cart_last_revision_at(cart) do
    # last_revision_at.strftime('%Y-%m-%d %H:%M')
    "TODO"
  end
end
