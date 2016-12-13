defmodule UM.Sales.OrderTest do
  use ExUnit.Case
  alias UM.Sales.Order

  test "creating an order" do
    order = Order.new
    assert order.id
    assert :pending == order.status
    assert Order.empty?(order)
    assert Order.list_price(order)
  end

  test "add item to an order" do
    order = Order.new
    item = %{id: "flute-piece"}
    quantity = 2
    order = Order.edit_line(order, %{item: item, quantity: quantity})
    refute Order.empty? order
  end

  test "edit existing line" do
    order = Order.new
    order = Order.edit_line(order, %{item: flute_part, quantity: 10})
    order = Order.edit_line(order, %{item: flute_part, quantity: 2})
    assert 1 == Order.number_of_lines(order)
    assert 2 == Order.number_of_units(order)
  end

  test "calculate list price " do
    order = Order.new
    order = Order.edit_line(order, %{item: flute_part, quantity: 10})
    order = Order.edit_line(order, %{item: piano_part, quantity: 2})
    assert 600 == Order.list_price(order)
  end

  test "can have a discount " do
    order = Order.new
    order = Order.edit_line(order, %{item: flute_part, quantity: 10})
    order = Order.add_discount(order, two_pounds_odd)
    assert 440 == Order.list_price(order)
    assert 200 == Order.discount_value(order)
    refute Order.free?(order)
  end

  test "can have a discount that makes the basket free" do
    order = Order.new
    order = Order.edit_line(order, %{item: piano_part, quantity: 2})
    order = Order.add_discount(order, two_pounds_odd)
    assert 160 == Order.list_price(order)
    assert 200 == Order.discount_value(order)
    assert Order.free?(order)
  end

  def two_pounds_odd do
    %UM.Sales.Discount{
      value: 200
    }
  end

  def flute_part do
    %{
      id: "flute-part",
      initial_price: 80,
      discounted_price: 40
    }
  end
  def piano_part do
    %{
      id: "piano-part",
      initial_price: 80,
      discounted_price: nil
    }
  end
end
