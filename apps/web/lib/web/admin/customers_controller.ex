defmodule UM.Web.Admin.CustomersController do
  import UM.Web.ViewHelpers
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(%{method: :GET, path: [], query: query}, _) do
    page = UM.Web.requested_page(query, page_size: 10)
    {:ok, page_of_customers} = UM.Accounts.CustomersRepo.index(page)
    Raxx.Response.ok(index_page_content(page_of_customers))
  end

  def handle_request(%{method: :POST, path: [id, "admin"]}, _) do
    {:ok, customer} = UM.Accounts.CustomersRepo.fetch_by_id(id)
    updated_customer = Map.merge(customer, %{admin: true})
    case UM.Accounts.CustomersRepo.update(updated_customer) do
      {:ok, latest} ->
        Raxx.Patch.redirect("/admin/customers")
        |> UM.Web.with_flash(success: "#{customer_name(latest)} is now an admin")
    end
  end

  def handle_request(%{method: :DELETE, path: [id, "admin"]}, _) do
    {:ok, customer} = UM.Accounts.CustomersRepo.fetch_by_id(id)
    updated_customer = Map.merge(customer, %{admin: false})
    case UM.Accounts.CustomersRepo.update(updated_customer) do
      {:ok, latest} ->
        Raxx.Patch.redirect("/admin/customers")
        |> UM.Web.with_flash(success: "#{customer_name(latest)} is now not an admin")
    end
  end
end
