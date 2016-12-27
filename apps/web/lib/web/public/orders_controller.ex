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
