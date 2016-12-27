defmodule UM.Sales.CartsRepo do
  import Moebius.Query

  def fetch_by_id(id) do
    query = db(:shopping_baskets) |> filter(id: id)
    case Moebius.Db.first(query) do
      nil ->
        {:error, :not_found}
      record = %{id: ^id} ->
        purchases_query = db(:purchases)
        |> filter(shopping_basket_id: id)
        purchases = Moebius.Db.run(purchases_query)
        purchases = Enum.map(purchases, fn
          (purchase = %{item_id: item_id}) ->
            query = db(:items) |> filter(id: item_id)
            item = Moebius.Db.first(query)
            {item.id, Map.merge(purchase, %{item: item})}
        end)
        |> Enum.into(%{})
        {:ok, struct(UM.Sales.Cart, Map.merge(record, %{purchases: purchases}))}
    end
  end

end
