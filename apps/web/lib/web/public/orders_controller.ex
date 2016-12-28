defmodule UM.Web.OrdersController do
  # checkout
  # def handle_request() do
  #   session = UM.Web.fetch_session(request)
  #   cart = UM.Web.Session.cart(session)
  #   ^cart_id = cart.id || "__empty__"
  #
  #   {:ok, order} = Cart.place_order
  #   Order.process(order)
  #   {:ok, %{status: complete}}
  #   # redirection
  #   # error
  #   Order.success
  #   Order.cancel
  # end

  def handle_request(%{path: [id], method: :GET}, _) do
    Raxx.Response.ok("hi")
  end
end
