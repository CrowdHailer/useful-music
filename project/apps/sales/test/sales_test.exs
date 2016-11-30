defmodule UM.SalesTest do
  use ExUnit.Case
  alias UM.Sales

  test "Can start a new basket" do
    # Same as createing a new shopping basket.
    # Shopping basket is just a pending order.
    # NOTE shopping basket has many orders because an order can fail.
    # Can just create new order if failed but the domain has a concept of a basket so we will use it.
    {:ok, basket = %{id: id}} = Sales.create_shopping_basket()
    assert Sales.ShoppingBasket.empty?(basket)
  end
end
