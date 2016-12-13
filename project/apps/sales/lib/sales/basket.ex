defmodule UM.Sales.Basket do
  @moduledoc """
  Existing system has 4 states for an order ['pending', 'processing', 'succeded', 'failed']
  Pending is almost immediatly replaced by processing

  A shopping basket is just a pending order, particularly as an order can have more than one transaction
  purchase can also be thought of as order line.
  We will have separate order and basket, order should be thought of as transaction.
  return locked basket from repo
  """
  defstruct [
    id: nil,
    status: :pending, # can be ['pending', 'processing', 'succeded', 'failed']
    purchases: %{},
    currency: nil,
    discount: nil
  ]

  def new do
    %__MODULE__{
      id: Utils.random_string(16)
    }
  end

  def empty?(order), do: number_of_lines(order) == 0

  def number_of_lines(%{purchases: purchases}), do: Enum.count(purchases)

  def number_of_units(%{purchases: purchases}) do
    Enum.reduce(purchases, 0, fn
      ({_item_id, %{quantity: n}}, total) ->
        total + n
    end)
  end

  def edit_line(order = %{purchases: purchases}, %{item: item, quantity: quantity}) do
    purchases = Map.put(purchases, item.id, %{item: item, quantity: quantity})
    %{order | purchases: purchases}
  end

  def list_price(%{purchases: purchases}) do
    Enum.reduce(purchases, 0, fn
      ({_item_id, purchase}, total) ->
        total + line_price(purchase)
    end)
  end

  def line_price(%{quantity: quantity, item: item}) do
    UM.Catalogue.Item.price_for(item, quantity)
  end

  def add_discount(order, discount) do
    %{order | discount: discount}
  end

  def discount_value(order) do
    case order.discount do
      nil ->
        0
      %{value: value} ->
        value
    end
  end

  def free?(order) do
    discount_value(order) > list_price(order)
  end

  def start_transaction(basket, %{vat_rate: vat_rate, currency: :GBP}) do
    list_price = list_price(basket)
    discount_value = discount_value(basket)
    payment_gross = list_price(basket) - discount_value(basket)
    tax_payment = payment_gross * vat_rate
    payment_net = payment_gross + tax_payment
    %{
      basket_total: list_price,
      discount_value: discount_value,
      payment_gross: payment_gross,
      tax_payment: tax_payment,
      payment_net: payment_net,
      currency: :GBP,
      basket: basket
    }
  end
end
