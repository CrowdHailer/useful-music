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

    {session, request} = UM.Web.Session.from_request(request)
    basket = case UM.Sales.fetch_shopping_basket(basket_id) do
      {:ok, basket} ->
        basket
      {:error, :not_found} ->
        {:ok, basket} = UM.Sales.create_shopping_basket
        basket
    end

    items |> Enum.map(fn
      ({item_id, quantity}) ->
        {quantity, ""} = Integer.parse(quantity)
        UM.Sales.add_item(basket.id, item_id, quantity: quantity)
    end)

    redirect = "/orders/#{basket.id}"
    {:ok, r} = Raxx.Patch.redirect(redirect, success: "Items added to basket")
    |> Raxx.Patch.set_header("um-set-session", %{session | shopping_basket_id: basket.id})
    r
  end

  def handle_request(request = %{
    path: [basket_id, "items", item_id],
    method: :PUT,
    body: %{"item" => item}
    }, _env) do

    {session, request} = UM.Web.Session.from_request(request)

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

    {session, request} = UM.Web.Session.from_request(request)

    UM.Sales.set_item(basket_id, item_id, quantity: 0)
    redirect = "/orders/#{basket_id}"
    {:ok, r} = Raxx.Patch.redirect(redirect, success: "Item removed from basket")
    |> Raxx.Patch.set_header("um-set-session",%{session | shopping_basket_id: basket_id})
    r
  end

  def handle_request(request = %{path: [id], method: :GET}, _) do
    {session, request} = UM.Web.Session.from_request(request)
    {:ok, basket} = UM.Sales.fetch_shopping_basket(id)
    Raxx.Response.ok(basket_page_content(basket, session))
  end

  defp local_price(_) do
    "0" # TODO
  end
  def initial_price(item) do
    UM.Catalogue.Item.initial_price(item)
  end
  def subsequent_price(item) do
    UM.Catalogue.Item.subsequent_price(item)
  end
  defp purchase_price(%{quantity: quantity, item: item}) do
    UM.Catalogue.Item.price_for(item, quantity)
  end
  defp current_customer(session) do
    UM.Web.Session.current_customer(session)
  end
  defp current_country(session) do
    nil # TODO
  end
  defp catalogue_price(basket) do
    1231 # TODO
  end
  defp vat_rate(session) do
    120 # TODO
  end
  defp currency_preference(session) do
    "GBP" # TODO
  end
  defp guest_visitor?(session) do
    false # TODO
  end
  def basket_price(basket) do
    0 # TODO
  end
  def discount_code(basket) do
    "TODO"
  end
  def free_basket?(basket) do

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
