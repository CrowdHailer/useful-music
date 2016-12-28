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

  def index(page) do
    query = db(:orders) |> sort(:id, :asc)
    case Moebius.Db.run(query) do
      {:error, reason} ->
        {:error, reason}
      entries ->
        carts = Enum.map(entries, &unpack/1)
        {:ok, Page.paginate(carts, page)}
    end
  end

  def customer_history(%{id: customer_id}) do
    # pull all orders that succeeded in the last 4 days
    # sorted by completion date
    IO.inspect(customer_id)
    query = db(:orders) |> filter(customer_id: customer_id) |> sort(:id, :asc)
    case Moebius.Db.run(query) do
      {:error, reason} ->
        {:error, reason}
      records ->
        IO.inspect(records)
        orders = Enum.map(records, &unpack/1)
        {:ok, orders} # DEBT does not paginate
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
    cart_total = record.basket_total
    record = Map.delete(record, :basket_total)

    Map.merge(record, %{cart_total: cart_total})
  end
end
