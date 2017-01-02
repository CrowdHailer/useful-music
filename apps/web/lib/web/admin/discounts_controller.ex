defmodule UM.Web.Admin.DiscountsController do
  import UM.Web.ViewHelpers
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_template, index_file, [:page]

  form_template_file = String.replace_suffix(__ENV__.file, ".ex", "/form.html.eex")
  EEx.function_from_file :def, :form_template, form_template_file, [:discount]

  alias __MODULE__.{EditForm}

  def handle_request(%{path: [], method: :GET, query: query}, _) do
    page = UM.Web.requested_page(query)
    {:ok, page_of_discounts} = UM.Sales.DiscountsRepo.index_by_code(page)
    Raxx.Response.ok(index_template(page_of_discounts))
  end

  def handle_request(%{path: ["new"], method: :GET}, _) do
    discount = %UM.Sales.Discount{id: nil}
    Raxx.Response.ok(form_template(discount))
  end

  def handle_request(%{path: [], method: :POST, body: %{"discount" => form}}, _) do
    case EditForm.validate(form) do
      {:ok, data} ->
        discount = Map.merge(data, %{id: Utils.random_string(16)})
        case UM.Sales.DiscountsRepo.insert(discount) do
          {:ok, discount} ->
            Raxx.Patch.redirect("/admin/discounts/#{discount.id}/edit", %{success: "Discount created"})
        end
      {:error, {form, errors}} ->
        IO.inspect(errors)
        Raxx.Patch.redirect("/admin/discounts/new", %{error: "Failed"})
    end
  end

  def handle_request(%{path: [id, "edit"], method: :GET}, _) do
    {:ok, discount} = UM.Sales.DiscountsRepo.fetch_by_id(id)
    Raxx.Response.ok(form_template(discount))
  end

  def handle_request(%{path: [id], method: :PUT, body: %{"discount" => form}}, _) do
    case EditForm.validate(form) do
      {:ok, data} ->
        discount = Map.merge(data, %{id: id})
        case UM.Sales.DiscountsRepo.update(discount) do
          {:ok, discount} ->
            Raxx.Patch.redirect("/admin/discounts/#{discount.id}/edit", %{success: "Discount updated"})
        end
    end
  end

  def form_title(%{id: nil}) do
    "New Discount"
  end
  def form_title(%{id: _id, code: code}) do
    "Edit Discount #{code}"
  end
end
