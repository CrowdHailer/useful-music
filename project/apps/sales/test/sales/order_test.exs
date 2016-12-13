defmodule UM.Sales.OrderTest do
  use ExUnit.Case
  alias UM.Sales.Order

  test "creating an order" do
    order = Order.new
    assert order.id
    assert :pending == order.status
    assert Order.empty?(order)
  end

  test "add item to an order" do
    order = Order.new
    item = %{id: "flute-piece"}
    quantity = 2
    order = Order.edit_line(order, %{item: item, quantity: quantity})
    refute Order.empty? order
  end

  test "edit existing line" do
    item = %{id: "flute-piece"}
    order = Order.new
    order = Order.edit_line(order, %{item: item, quantity: 10})
    order = Order.edit_line(order, %{item: item, quantity: 2})
    assert 1 == Order.number_of_lines(order)
    assert 2 == Order.number_of_units(order)
  end
end
