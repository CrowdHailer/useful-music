defmodule UM.Sales.BasketTest do
  use ExUnit.Case
  alias UM.Sales.Basket

  test "creating an basket" do
    basket = Basket.new
    assert basket.id
    assert :pending == basket.status
    assert Basket.empty?(basket)
    assert Basket.list_price(basket)
  end

  test "add item to an basket" do
    basket = Basket.new
    item = %{id: "flute-piece"}
    quantity = 2
    basket = Basket.edit_line(basket, %{item: item, quantity: quantity})
    refute Basket.empty? basket
  end

  test "edit existing line" do
    basket = Basket.new
    basket = Basket.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Basket.edit_line(basket, %{item: flute_part, quantity: 2})
    assert 1 == Basket.number_of_lines(basket)
    assert 2 == Basket.number_of_units(basket)
  end

  test "calculate list price " do
    basket = Basket.new
    basket = Basket.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Basket.edit_line(basket, %{item: piano_part, quantity: 2})
    assert 600 == Basket.list_price(basket)
  end

  test "can have a discount " do
    basket = Basket.new
    basket = Basket.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Basket.add_discount(basket, two_pounds_odd)
    assert 440 == Basket.list_price(basket)
    assert 200 == Basket.discount_value(basket)
    refute Basket.free?(basket)
  end

  test "can have a discount that makes the basket free" do
    basket = Basket.new
    basket = Basket.edit_line(basket, %{item: piano_part, quantity: 2})
    basket = Basket.add_discount(basket, two_pounds_odd)
    assert 160 == Basket.list_price(basket)
    assert 200 == Basket.discount_value(basket)
    assert Basket.free?(basket)
  end

  test "can start transaction" do
    basket = Basket.new
    basket = Basket.edit_line(basket, %{item: flute_part, quantity: 10})
    basket = Basket.add_discount(basket, two_pounds_odd)
    transaction = Basket.start_transaction(basket, %{vat_rate: 0.2, currency: :GBP})
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
