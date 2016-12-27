defmodule UM.Sales.CartTest do
  use ExUnit.Case
  alias UM.Sales.Cart

  test "creating an basket" do
    basket = Cart.new
    assert basket.id
    assert :pending == basket.status
    assert Cart.empty?(basket)
    assert Cart.list_price(basket)
  end

  test "add item to an basket" do
    basket = Cart.new
    item = %{id: "flute-piece"}
    quantity = 2
    basket = Cart.edit_line(basket, %{item: item, quantity: quantity})
    refute Cart.empty? basket
  end

  test "edit existing line" do
    basket = Cart.new
    basket = Cart.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Cart.edit_line(basket, %{item: flute_part, quantity: 2})
    assert 1 == Cart.number_of_lines(basket)
    assert 2 == Cart.number_of_units(basket)
  end

  test "calculate list price " do
    basket = Cart.new
    basket = Cart.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Cart.edit_line(basket, %{item: piano_part, quantity: 2})
    assert 600 == Cart.list_price(basket)
  end

  test "can have a discount " do
    basket = Cart.new
    basket = Cart.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Cart.add_discount(basket, two_pounds_odd)
    assert 440 == Cart.list_price(basket)
    assert 200 == Cart.discount_value(basket)
    refute Cart.free?(basket)
  end

  test "can have a discount that makes the basket free" do
    basket = Cart.new
    basket = Cart.edit_line(basket, %{item: piano_part, quantity: 2})
    basket = Cart.add_discount(basket, two_pounds_odd)
    assert 160 == Cart.list_price(basket)
    assert 200 == Cart.discount_value(basket)
    assert Cart.free?(basket)
  end

  test "can start transaction" do
    basket = Cart.new
    basket = Cart.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Cart.add_discount(basket, two_pounds_odd)
    transaction = Cart.start_transaction(basket, %{vat_rate: 0.2, currency: :GBP})
    assert 440 == transaction.basket_total
    assert 200 == transaction.discount_value
    assert 240 == transaction.payment_gross
    assert 48 == transaction.tax_payment
    assert 288 == transaction.payment_net
    assert :GBP == transaction.currency
    assert basket == transaction.basket
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
