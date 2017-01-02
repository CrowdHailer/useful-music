defmodule UM.Web.CartsController do
  import UM.Web.ViewHelpers
  require EEx

  show_template = String.replace_suffix(__ENV__.file, ".ex", "/show.html.eex")
  EEx.function_from_file :def, :show_page, show_template, [:cart, :order, :session]

  def handle_request(request = %{path: [cart_id], method: :GET}, _) do
    session = UM.Web.fetch_session(request)
    cart = UM.Web.Session.cart(session)
    authorized = cart_id == cart.id || cart_id == "__empty__"
    case authorized do
      true ->
        {:ok, order} = UM.Sales.Cart.checkout(cart, %{
          currency: "GBP",
          vat_rate: 0.2,
          customer_id: "could-be-guest"
        })
        Raxx.Response.ok(show_page(cart, order, session))
      false ->
        Raxx.Response.forbidden("Forbidden")
    end
  end

  # PATCH /:cart_id/purchases
  def handle_request(request = %{path: [cart_id, "purchases"], method: :PATCH, body: %{"purchases" => form}}, _) do
    session = UM.Web.fetch_session(request)
    cart = UM.Web.Session.cart(session)
    ^cart_id = cart.id || "__empty__"

    purchases = for {item_id, quantity} <- form, into: %{} do
      {quantity, ""} = Integer.parse(quantity)
      {item_id, quantity}
    end

    {:ok, cart} = UM.Sales.edit_purchases(cart, purchases)
    session = UM.Web.Session.update_shopping_basket(session, cart)

    Raxx.Patch.redirect("/shopping_baskets/#{cart.id}")
    |> UM.Web.with_flash(success: "Items added to basket")
    |> UM.Web.with_session(session)
  end

  # TODO test
  def handle_request(request = %{path: [cart_id, "discount"], method: :PUT, body: %{"shopping_basket" => form}}, _) do
    session = UM.Web.fetch_session(request)
    cart = UM.Web.Session.cart(session)
    ^cart_id = cart.id || "__empty__"

    discount_code = Map.get(form, "discount", "") |> String.upcase
    {cart, flash} = case UM.Sales.apply_discount_code(cart, discount_code) do
      {:ok, cart = %{discount_id: nil}} ->
        {cart, success: "Discount Code Removed"}
      {:ok, cart = %{discount_id: _something}} ->
        {cart, success: "Discount Code Added"}
      {:error, reason} ->
        {cart, error: reason}
    end

    Raxx.Patch.redirect("/shopping_baskets/#{cart.id}")
    |> UM.Web.with_flash(flash)
    |> UM.Web.with_session(session)
  end

  # TODO test
  def handle_request(request = %{path: [cart_id, "checkout"], method: :POST}, _) do
    session = UM.Web.fetch_session(request)
    cart = UM.Web.Session.cart(session)
    authorized = cart_id == cart.id || cart_id == "__empty__"
    case authorized do
      true ->
        # TODO handle currency
        {:ok, order} = UM.Sales.Cart.checkout(cart, %{
          vat_rate: 0.2,
          currency: "GBP",
          customer_id: UM.Web.Session.current_customer(session).id
        })
        order = %{order | id: Utils.random_string(16)}
        {:ok, order} = UM.Sales.OrdersRepo.insert(order)
        Raxx.Patch.redirect("/orders/#{order.id}")
      false ->
        Raxx.Response.forbidden("Forbidden")
    end
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
