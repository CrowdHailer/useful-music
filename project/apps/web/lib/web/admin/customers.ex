defmodule UM.Web.Admin.Customers do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(%{method: :GET, path: [], query: query}, _) do
    size = Map.get(query, "page_size", "10") |> :erlang.binary_to_integer
    page = Map.get(query, "page", "1") |> :erlang.binary_to_integer
    customers = [
      %{id: 23, name: "bill", email: "bill@yahoo.com", admin: false},
      %{id: 23, name: "susan", email: "susan@yahoo.com", admin: true},
    ]
    Raxx.Response.ok(UM.Web.Admin.layout_page(index_page_content(%{
      size: size,
      previous: max(page - 1, 0),
      next: page + 1,
      last: 10,
      customers: Enum.zip(customers, 1..Enum.count(customers))
      })))
  end

  def csrf_tag do
    "TODO"
  end
end
