defmodule UM.Sales.CartTest do
  use ExUnit.Case
  alias UM.Sales.Cart

  test "creating an cart" do
    cart = Cart.empty
    assert Cart.empty?(cart)
    assert Cart.list_price(cart)
  end

  test "add item to an cart" do
    cart = Cart.empty
    item = %{id: "flute-piece"}
    quantity = 2
    cart = Cart.edit_line(cart, %{item: item, quantity: quantity})
    refute Cart.empty? cart
  end

  test "edit existing line" do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: flute_part, quantity: 10})
    cart = Cart.edit_line(cart, %{item: flute_part, quantity: 2})
    assert 1 == Cart.number_of_lines(cart)
    assert 2 == Cart.number_of_units(cart)
  end

  test "calculate list price " do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: flute_part, quantity: 10})
    cart = Cart.edit_line(cart, %{item: piano_part, quantity: 2})
    assert Money.new(600, :GBP) == Cart.list_price(cart)
  end

  test "can have a discount " do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: flute_part, quantity: 10})
    cart = Cart.add_discount(cart, two_pounds_odd)
    assert Money.new(440, :GBP) == Cart.list_price(cart)
    assert Money.new(200, :GBP) == Cart.discount_value(cart)
    refute Cart.free?(cart)
  end

  test "can have a discount that makes the cart free" do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: piano_part, quantity: 2})
    cart = Cart.add_discount(cart, two_pounds_odd)
    assert Money.new(160, :GBP) == Cart.list_price(cart)
    assert Money.new(200, :GBP) == Cart.discount_value(cart)
    assert Cart.free?(cart)
  end

  test "can start transaction" do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: flute_part, quantity: 10})
    cart = Cart.add_discount(cart, two_pounds_odd)
    {:ok, order} = Cart.checkout(cart, %{vat_rate: 0.2, currency: "GBP", customer_id: "hi"})
    assert Money.new(440, :GBP) == order.cart_total
    assert Money.new(200, :GBP) == order.discount_value
    assert Money.new(240, :GBP) == order.payment_gross
    assert Money.new(48, :GBP) == order.tax_payment
    assert Money.new(288, :GBP) == order.payment_net
    assert "GBP" == order.currency
    assert cart == order.cart
  end

  def two_pounds_odd do
    %UM.Sales.Discount{
      value: Money.new(200, :GBP)
    }
  end

  def flute_part do
    %{
      id: "flute-part",
      initial_price: Money.new(80, :GBP),
      discounted_price: Money.new(40, :GBP)
    }
  end
  def piano_part do
    %{
      id: "piano-part",
      initial_price: Money.new(80, :GBP),
      discounted_price: nil
    }
  end
end
