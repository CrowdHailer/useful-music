defmodule UM.Web.Admin.DiscountsController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_template, index_file, [:page]

  form_template_file = String.replace_suffix(__ENV__.file, ".ex", "/form.html.eex")
  EEx.function_from_file :def, :form_template, form_template_file, [:discount]

  alias __MODULE__.{EditForm}

  def handle_request(request = %{path: [], method: :GET}, _) do
    {:ok, page_of_discounts} = UM.Sales.Discounts.index_by_code(%{page_size: 12, page_number: 1})
    Raxx.Response.ok(index_template(page_of_discounts))
  end

  def handle_request(request = %{path: ["new"], method: :GET}, _) do
    discount = %UM.Sales.Discount{id: nil}
    Raxx.Response.ok(form_template(discount))
  end

  def handle_request(request = %{path: [], method: :POST, body: %{"discount" => form}}, _) do
    case EditForm.validate(form) do
      {:ok, data} ->
        discount = Map.merge(data, %{id: Utils.random_string(16)})
        case UM.Sales.Discounts.insert(discount) do
          {:ok, discount} ->
            Raxx.Patch.redirect("/admin/discounts/#{discount.id}", %{success: "Discount created"})
        end
      {:error, {form, errors}} ->
        IO.inspect(errors)
        Raxx.Patch.redirect("/admin/discounts/new", %{error: "Failed"})
    end
  end

  def discount_value(_) do
    "TODO"
  end

  def number_redeemed(_) do
    "TODO"
  end

  def discount_start_datetime(_) do
    # .strftime('%Y-%m-%d')
    "TODO"
  end

  def discount_end_datetime(_) do
    # .strftime('%Y-%m-%d')
    "TODO"
  end

  def form_title(%{id: nil}) do
    "New Discount"
  end
  def form_title(%{id: _id, code: code}) do
    "Edit Discount #{code}"
  end
end
