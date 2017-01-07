defmodule UM.Sales.OrdersRepo do
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
    query = db(:orders) |> filter(customer_id: customer_id) |> sort(:completed_at, :asc)
    case Moebius.Db.run(query) do
      {:error, reason} ->
        {:error, reason}
      records ->
        orders = Enum.map(records, &unpack/1)
        {:ok, orders} # DEBT does not paginate
    end
  end

  def available_orders(%{id: customer_id}) do
    # pull all orders that succeeded in the last 4 days
    # sorted by completion date
    query = db(:orders)
      |> filter(customer_id: customer_id, state: "succeded")
      |> sort(:completed_at, :asc)
    case Moebius.Db.run(query) do
      {:error, reason} ->
        {:error, reason}
      records ->
        orders = Enum.map(records, &unpack/1)
        {:ok, orders} # DEBT does not paginate
    end
  end

  # make discount value required
  def insert(order = %{id: id}) when is_binary(id) do
    %Money{amount: cart_total, currency: :GBP} = order.cart_total
    order = %{order | cart_total: cart_total}
    %Money{amount: payment_gross, currency: :GBP} = order.payment_gross
    order = %{order | payment_gross: payment_gross}
    %Money{amount: payment_net, currency: :GBP} = order.payment_net
    order = %{order | payment_net: payment_net}
    %Money{amount: tax_payment, currency: :GBP} = order.tax_payment
    order = %{order | tax_payment: tax_payment}
    %Money{amount: discount_value, currency: :GBP} = order.discount_value
    order = %{order | discount_value: discount_value}

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

    # TODO remove explicit reference to cart
    Map.merge(record, %{cart_total: cart_total, cart: UM.Sales.Cart.empty})
  end
end
