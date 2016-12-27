defmodule UM.Web.Admin.CustomersController do
  import UM.Web.ViewHelpers
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(%{method: :GET, path: [], query: query}, _) do
    query = query || %{}
    size = Map.get(query, "page_size", "10") |> :erlang.binary_to_integer
    page = Map.get(query, "page", "1") |> :erlang.binary_to_integer
    # TODO paginate properly
    customers = UM.Accounts.all_customers

    Raxx.Response.ok(index_page_content(%{
      size: size,
      previous: max(page - 1, 0),
      next: page + 1,
      last: 10,
      customers: Enum.zip(customers, 1..Enum.count(customers))
      }))
  end

  def handle_request(%{method: :POST, path: [id, "admin"]}, _) do
    {:ok, customer} = UM.Accounts.fetch_by_id(id)
    updated_customer = Map.merge(customer, %{admin: true})
    case UM.Accounts.update_customer(updated_customer) do
      {:ok, latest} ->
        Raxx.Patch.redirect("/admin/customers")
        |> UM.Web.with_flash(success: "#{customer_name(latest)} is now an admin")
    end
  end

  def handle_request(%{method: :DELETE, path: [id, "admin"]}, _) do
    {:ok, customer} = UM.Accounts.fetch_by_id(id)
    updated_customer = Map.merge(customer, %{admin: false})
    case UM.Accounts.update_customer(updated_customer) do
      {:ok, latest} ->
        Raxx.Patch.redirect("/admin/customers")
        |> UM.Web.with_flash(success: "#{customer_name(latest)} is now not an admin")
    end
  end
end
