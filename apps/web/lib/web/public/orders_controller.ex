defmodule UM.Web.OrdersController do
  import UM.Web.ViewHelpers
  require EEx

  basket_file = String.replace_suffix(__ENV__.file, ".ex", "/basket.html.eex")
  EEx.function_from_file :def, :basket_page_content, basket_file, [:basket, :session]

  def handle_request(request = %{
    path: [basket_id, "items"],
    method: :POST,
    body: %{"items" => items}
    }, _env) do

    # check authorization? session basket == basket
    # validate input
    session = UM.Web.fetch_session(request)
    shopping_basket = UM.Web.Session.shopping_basket(session)
    ^basket_id = shopping_basket.id || "__empty__"

    {:ok, shopping_basket} = UM.Sales.add_items(shopping_basket, items)
    session = UM.Web.Session.update_shopping_basket(session, shopping_basket)

    Raxx.Patch.redirect("/orders/#{shopping_basket.id}")
    |> UM.Web.with_flash(success: "Items added to basket")
    |> UM.Web.with_session(session)
  end

  def handle_request(request = %{
    path: [basket_id, "items", item_id],
    method: :PUT,
    body: %{"item" => item}
    }, _env) do

    session = UM.Web.fetch_session(request)

    quantity = Map.get(item, "quantity")
    {quantity, ""} = Integer.parse(quantity)
    UM.Sales.set_item(basket_id, item_id, quantity: quantity)
    redirect = "/orders/#{basket_id}"
    {:ok, r} = Raxx.Patch.redirect(redirect, success: "Shopping basket updated")
    |> Raxx.Patch.set_header("um-set-session", %{session | shopping_basket_id: basket_id})
    r
  end

  def handle_request(request = %{
    path: [basket_id, "items", item_id],
    method: :DELETE
    }, _env) do

    session = UM.Web.fetch_session(request)

    UM.Sales.set_item(basket_id, item_id, quantity: 0)
    redirect = "/orders/#{basket_id}"
    {:ok, r} = Raxx.Patch.redirect(redirect, success: "Item removed from basket")
    |> Raxx.Patch.set_header("um-set-session",%{session | shopping_basket_id: basket_id})
    r
  end

  def handle_request(request = %{path: [id], method: :GET}, _) do
    session = UM.Web.fetch_session(request)
    {:ok, basket} = UM.Sales.fetch_shopping_basket(id)
    Raxx.Response.ok(basket_page_content(basket, session))
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
