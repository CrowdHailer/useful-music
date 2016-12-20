defmodule UM.Web.Admin.DiscountsController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_template, index_file, [:page]

  def handle_request(request = %{path: [], method: :GET}, _) do
    {:ok, page_of_discounts} = UM.Sales.Discounts.index_by_code(%{page_size: 12, page_number: 1})
    Raxx.Response.ok(index_template(page_of_discounts))
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
end
