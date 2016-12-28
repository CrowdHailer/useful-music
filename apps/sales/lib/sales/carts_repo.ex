defmodule UM.Sales.CartsRepo do
  import Moebius.Query

  def fetch_by_id(id) do
    query = db(:shopping_baskets) |> filter(id: id)
    case Moebius.Db.first(query) do
      nil ->
        {:error, :not_found}
      record = %{id: ^id} ->
        cart = unpack(record)
        {:ok, cart}
    end
  end

  def index(page) do
    query = db(:shopping_baskets) |> sort(:id, :asc)
    case Moebius.Db.run(query) do
      {:error, reason} ->
        {:error, reason}
      entries ->
        carts = Enum.map(entries, &unpack/1)
        {:ok, Page.paginate(carts, page)}
    end
  end

  defp unpack(record) do
    purchases_query = db(:purchases)
    |> filter(shopping_basket_id: record.id)
    purchases = Moebius.Db.run(purchases_query)
    purchases = Enum.map(purchases, fn
      (purchase = %{item_id: item_id}) ->
        query = db(:items) |> filter(id: item_id)
        item = Moebius.Db.first(query)
        {item.id, Map.merge(purchase, %{item: item})}
    end)
    |> Enum.into(%{})
    discount = if record.discount_id do
      {:ok, discount} = UM.Sales.Discounts.fetch_by_id(record.discount_id)
      discount
    end
    struct(UM.Sales.Cart, Map.merge(record, %{purchases: purchases, discount: discount}))
  end
end
