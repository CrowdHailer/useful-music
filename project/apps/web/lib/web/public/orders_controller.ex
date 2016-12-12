defmodule UM.Web.OrdersController do
  def handle_request(request = %{
    path: [basket_id, "items"],
    method: :POST,
    body: %{"items" => items}
    }, _env) do

    session = UM.Web.Session.get(request)
    |> IO.inspect

    items |> Enum.map(fn
      ({item_id, quantity}) ->
        {quantity, ""} = Integer.parse(quantity)
        UM.Sales.add_item(basket_id, item_id, quantity: quantity)
    end)
    |> IO.inspect
    # redirect = Raxx.Patch.referrer(request) || "/shopping_baskets/#{basket_id}"
    redirect = "/shopping_baskets/#{basket_id}"
    {:ok, r} = Raxx.Patch.redirect(redirect, success: "Items added to basket")
    |> Raxx.Patch.set_header("um-set-session", Map.merge(session, %{basket_id: basket_id}))
    r
  end

  def handle_request(request = %{
    path: [basket_id, "items", item_id],
    method: :PUT,
    body: %{"item" => item}
    }, _env) do

    session = UM.Web.Session.get(request)
    |> IO.inspect

    quantity = Map.get(item, "quantity")
    {quantity, ""} = Integer.parse(quantity)
    UM.Sales.set_item(basket_id, item_id, quantity: quantity)
    |> IO.inspect
    # redirect = Raxx.Patch.referrer(request) || "/shopping_baskets/#{basket_id}"
    redirect = "/shopping_baskets/#{basket_id}"
    {:ok, r} = Raxx.Patch.redirect(redirect, success: "Shopping basket updated")
    |> Raxx.Patch.set_header("um-set-session", Map.merge(session, %{basket_id: basket_id}))
    r
  end

  def handle_request(request = %{
    path: [basket_id, "items", item_id],
    method: :DELETE
    }, _env) do

    session = UM.Web.Session.get(request)
    |> IO.inspect

    UM.Sales.set_item(basket_id, item_id, quantity: 0)
    |> IO.inspect
    # redirect = Raxx.Patch.referrer(request) || "/shopping_baskets/#{basket_id}"
    redirect = "/shopping_baskets/#{basket_id}"
    {:ok, r} = Raxx.Patch.redirect(redirect, success: "Item removed from basket")
    |> Raxx.Patch.set_header("um-set-session", Map.merge(session, %{basket_id: basket_id}))
    r
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
