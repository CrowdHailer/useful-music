defmodule UM.Sales.ShoppingBasket do
  defstruct [
    id: nil,
    purchases: []
  ]

  def empty?(%{purchases: []}), do: true
  def empty?(%{purchases: [%{item: _item} | _rest]}), do: false

  # special case 0
  def change_purchase_quantity(basket, item, quantity) do
    # This action might be worth saving
  end
end
