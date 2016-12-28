defmodule UM.Sales.Orders do
  import Moebius.Query

  def fetch_by_id(id) do
    query = db(:orders) |> filter(id: id)
    case Moebius.Db.first(query) do
      record = %{id: ^id} ->
        {:ok, unpack(record)}
      nil ->
        {:error, :not_found}
    end
  end

  def insert(order = %{id: id}) when is_binary(id) do
    basket_total = order.cart_total
    shopping_basket_id = order.cart.id
    order = Map.delete(order, :__struct__)
    order = Map.delete(order, :cart)
    order = Map.delete(order, :cart_total)
    order = Map.merge(order, %{basket_total: basket_total})
    order = Map.merge(order, %{shopping_basket_id: shopping_basket_id})
    order = Enum.map(order, fn(x) -> x end)
    action = db(:orders) |> insert(order)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, unpack(record)}
    end
  end

  def unpack(record) do
    record
  end
end
