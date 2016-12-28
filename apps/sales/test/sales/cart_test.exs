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
    assert 600 == Cart.list_price(cart)
  end

  test "can have a discount " do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: flute_part, quantity: 10})
    cart = Cart.add_discount(cart, two_pounds_odd)
    assert 440 == Cart.list_price(cart)
    assert 200 == Cart.discount_value(cart)
    refute Cart.free?(cart)
  end

  test "can have a discount that makes the cart free" do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: piano_part, quantity: 2})
    cart = Cart.add_discount(cart, two_pounds_odd)
    assert 160 == Cart.list_price(cart)
    assert 200 == Cart.discount_value(cart)
    assert Cart.free?(cart)
  end

  test "can start transaction" do
    cart = Cart.empty
    cart = Cart.edit_line(cart, %{item: flute_part, quantity: 10})
    cart = Cart.add_discount(cart, two_pounds_odd)
    transaction = Cart.place_order(cart, %{vat_rate: 0.2, currency: :GBP})
    assert 440 == transaction.cart_total
    assert 200 == transaction.discount_value
    assert 240 == transaction.payment_gross
    assert 48 == transaction.tax_payment
    assert 288 == transaction.payment_net
    assert :GBP == transaction.currency
    assert cart == transaction.cart
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
