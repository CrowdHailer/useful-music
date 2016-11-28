defmodule UM.Web.Admin.Customers do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(%{method: :GET, path: [], query: query}, _) do
    # TODO decide if query can be nil
    query = query || %{}
    size = Map.get(query, "page_size", "10") |> :erlang.binary_to_integer
    page = Map.get(query, "page", "1") |> :erlang.binary_to_integer
    customers = [
      %{id: 23, name: "Issac", email: "issac@yahoo.com", admin: false},
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

  def handle_request(request = %{method: :POST, path: [id, "admin"]}, _) do
    # IO.inspect(id)
    {:ok, form} = Raxx.Request.content(request)
    case Map.get(form, "_method") do
      nil ->
        Raxx.Response.see_other("", [{"location", "/admin/customers"}])
      "DELETE" ->
        Raxx.Response.see_other("", [{"location", "/admin/customers"}])
    end
  end

  def csrf_tag do
    "todo csrf tag"
  end
end
