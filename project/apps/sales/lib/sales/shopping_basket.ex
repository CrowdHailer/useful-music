defmodule UM.Sales.ShoppingBasket do
  defstruct [
    id: nil,
    purchases: []
  ]

  def empty?(%{purchases: []}), do: true
  def empty?(%{purchases: [%{item_id: _item} | _rest]}), do: false

  # special case 0
  # def change_purchase_quantity(basket, item, quantity) do
  #   # This action might be worth saving
  # end
  #
  # def update_purchases(basket, [item | rest]) do
  #   update_purchases(basket, item)
  # end
  # def update_purchase(%{id: basket_id}, %{quantity: quantity, item_id: item_id}) do
  #   db(:purchases)
  #   |> filter(:basket_id => :basket_id, item_id: item_id)
  #   |> insert(:quantity: quantity)
  #   |> Db.run
  # end

  # add purchases the same but add what we had before

  def number_of_purchases(%{purchases: purchases}) do
    Enum.count(purchases)
  end

  def number_of_licences(%{purchases: purchases}) do
    Enum.reduce(purchases, 0, fn
      (%{quantity: n}, total) ->
        total + n
    end)
  end
end
