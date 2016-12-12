defmodule UM.Web.PurchasesController do
  def handle_request(request = %{path: [], method: :POST, body: %{"purchases" => form}}, _env) do
    {:ok, shopping_basket} = case form["shopping_basket"] do
      "" ->
        UM.Sales.create_shopping_basket
    end
    results = form["items"]
    |> Enum.map(fn
      ({item_id, quantity}) ->
        UM.Sales.add_item(shopping_basket, item_id, quantity: quantity)
    end)
    redirect = Raxx.Patch.referrer(request) || "/shopping_baskets/#{shopping_basket.id}"
    Raxx.Patch.redirect(redirect, success: "Items added to basket")

  end
end

# creation adds many
# (1) POST /orders/id/items/ []{item_id:, quantity:}
# update is one at a time
# (2) PATCH /orders/id/items/id %{quantity}
# Delete is one at a time
# (2.5, patch to zero) DELETE /orders/id/items/id
# Could have a method that loads the current number of items in basket.
# Also lets assume that there will never be conflict

# (3) PATCH /orders/id/discount/id %{quantity}
# (4) DELETE shopping basket abandon cart
# GET /orders/id/checkout
# (5) POST /orders/id/checkout -> pending
# (6/7) POST /orders/id/transaction/id -> success fail


defmodule UM.Web.Purchases do
  # def handle_request(%{path: [], method: :POST}, _) do
  #   my_basket
  #   # only error case is if number or items added == 0
  #   purchases = body.purchases
  #   Sales.make_purchases(my_basket, purchases)
  #   redirect(referer/my_shotting_basker)
  # end
  #
  # def handle_request(%{path: [id], method: :PATCH}, _) do
  #   quantity
  #   # can edit a brought order
  #   Sales.edit_quantity(id, quantity)
  # end
  # # Instead update basket
  #
  # # delete purchase just update items to 0
  # def handle_request do
  #
  # end
end
