defmodule UM.Web.OrdersController do
  # checkout
  # def handle_request() do
  #   session = UM.Web.fetch_session(request)
  #   cart = UM.Web.Session.cart(session)
  #   ^cart_id = cart.id || "__empty__"
  #
  #   {:ok, order} = Cart.checkout
  #   Order.process(order)
  #   {:ok, %{status: complete}}
  #   # redirection
  #   # error
  #   Order.success
  #   Order.cancel
  # end
  import UM.Web.ViewHelpers
  require EEx

  show_template = String.replace_suffix(__ENV__.file, ".ex", "/show.html.eex")
  EEx.function_from_file :def, :show_page, show_template, [:order, :cart]

  def handle_request(%{path: [id], method: :GET}, _) do
    case UM.Sales.Orders.fetch_by_id(id) do
      {:ok, order} ->
        {:ok, cart} = UM.Sales.CartsRepo.fetch_by_id(order.shopping_basket_id)
        Raxx.Response.ok(show_page(order, cart))
    end
  end

  def handle_request(_, _) do
    :no_match
  end
end
