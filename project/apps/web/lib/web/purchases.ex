defmodule UM.Web.Purchases do
  def handle_request(%{path: [], method: :POST}, _) do
    my_basket
    # only error case is if number or items added == 0
    purchases = body.purchases
    Sales.make_purchases(my_basket, purchases)
    redirect(referer/my_shotting_basker)
  end

  def handle_request(%{path: [id], method: :PATCH}, _) do
    quantity
    # can edit a brought order
    Sales.edit_quantity(id, quantity)
  end
  # Instead update basket

  # delete purchase just update items to 0
  def handle_request do

  end
end
