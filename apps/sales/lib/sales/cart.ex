defmodule UM.Sales.Cart do
  @moduledoc """
  Existing system has 4 states for an order ['pending', 'processing', 'succeded', 'failed']
  Pending is almost immediatly replaced by processing

  A shopping cart is just a pending order, particularly as an order can have more than one transaction
  purchase can also be thought of as order line.
  We will have separate order and order, cart should be thought of as transaction.
  return locked cart from repo
  """
  defstruct [
    id: nil,
    purchases: %{},
    discount: nil
  ]
  def empty do
    %__MODULE__{}
  end

  def empty?(cart), do: number_of_lines(cart) == 0

  # Checkout price
  def payment_gross(cart) do
    price = Money.subtract(list_price(cart), discount_value(cart))
    if Money.positive?(price) do
      price
    else
      Money.new(0, :GBP)
    end
  end

  def checkout_price(cart) do
    payment_gross(cart)
  end

  def free?(cart) do
    discount_value(cart) > list_price(cart)
  end

  def list_price(%{purchases: purchases}) do
    Enum.reduce(purchases, Money.new(0, :GBP), fn
      ({_item_id, purchase}, total) ->
        Money.add(total, line_price(purchase))
    end)
  end

  def discount_value(cart) do
    case cart.discount do
      nil ->
        0
      %{value: value} ->
        value
    end
  end

  def referenced?(cart) do
    # Does the cart have,
    # a) customer that has it as there current cart
    # b) an order that uses it
    # TODO
    true
  end

  def line_price(%{quantity: quantity, item: item}) do
    UM.Catalogue.Item.price_for(item, quantity)
  end

  def line_items(cart = %{purchases: purchases}) do
    for {_id, purchase} <- purchases do
      %{quantity: quantity, item: item} = purchase
      {quantity, item}
    end
    |> Enum.sort_by(fn({_, item}) -> item.piece_id end)
  end

  def number_of_lines(%{purchases: purchases}), do: Enum.count(purchases)

  def number_of_units(%{purchases: purchases}) do
    Enum.reduce(purchases, 0, fn
      ({_item_id, %{quantity: n}}, total) ->
        total + n
    end)
  end

  def edit_line(cart = %{purchases: purchases}, %{item: item, quantity: quantity}) do
    purchases = Map.put(purchases, item.id, %{item: item, quantity: quantity})
    %{cart | purchases: purchases}
  end

  def add_discount(cart, discount) do
    %{cart | discount: discount}
  end

  @doc """
  # On the order
  basket_total in old app is not cart_total
  cart_total is the total list price of the items in the user currency

  payment_gross on an order is the checkout price of the cart, never less than zero
  """
  def checkout(cart, %{vat_rate: vat_rate, currency: "GBP", customer_id: customer_id}) do
    list_price = list_price(cart)
    discount_value = discount_value(cart)
    payment_gross = checkout_price(cart)
    tax_payment = Money.multiply(payment_gross, vat_rate)
    payment_net = Money.add(payment_gross, tax_payment)
    {:ok, %UM.Sales.Order{
      customer_id: customer_id,
      state: "pending",
      cart_total: list_price,
      discount_value: discount_value,
      payment_gross: payment_gross,
      tax_payment: tax_payment,
      payment_net: payment_net,
      currency: "GBP",
      # vat_rate: vat_rate,
      cart: cart
    }}
  end
end
