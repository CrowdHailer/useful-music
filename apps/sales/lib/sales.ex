defmodule UM.Sales do
  use Application
  import Moebius.Query

  def create_shopping_basket do
    query = db(:shopping_baskets) |> insert(id: random_string(16))
    case Moebius.Db.run(query) do
      {:error, reason} ->
        IO.inspect(reason)
        {:error, reason}
      record ->
        {:ok, struct(UM.Sales.Cart, record)}
    end
  end

  def add_items(shopping_basket, items) do
    shopping_basket = case shopping_basket do
      %{id: nil} ->
        {:ok, shopping_basket} = create_shopping_basket
        shopping_basket
      shopping_basket ->
        shopping_basket
    end
    items |> Enum.map(fn
      ({item_id, quantity}) ->
        {quantity, ""} = Integer.parse(quantity)
        UM.Sales.add_item(shopping_basket.id, item_id, quantity: quantity)
    end)
    fetch_shopping_basket(shopping_basket.id)
  end

  def add_item(basket_id, item_id, opts \\ []) do
    opts = Enum.into(opts, %{})
    quantity = Map.get(opts, :quantity, 1)
    query = db(:purchases)
    |> filter(shopping_basket_id: basket_id, item_id: item_id)
    update = case Moebius.Db.run(query) do
      [] ->
        db(:purchases)
        |> insert(shopping_basket_id: basket_id, item_id: item_id, quantity: quantity, id: random_string(16))
    end
    Moebius.Db.run(update)
  end

  def set_item(basket_id, item_id, opts \\ []) do
    opts = Enum.into(opts, %{})
    quantity = Map.get(opts, :quantity, 1)
    query = db(:purchases)
    |> filter(shopping_basket_id: basket_id, item_id: item_id)
    update = case {Moebius.Db.run(query), quantity} do
      {[], q} ->
        db(:purchases)
        |> insert(shopping_basket_id: basket_id, item_id: item_id, quantity: quantity, id: random_string(16))
      {[_item], 0} ->
        db(:purchases)
        |> filter(shopping_basket_id: basket_id, item_id: item_id)
        |> delete
      {[_item], q} ->
        db(:purchases)
        |> filter(shopping_basket_id: basket_id, item_id: item_id)
        |> update(quantity: quantity)
    end
    Moebius.Db.run(update)
  end

  def fetch_shopping_basket(basket_id) do
    basket_query = db(:shopping_baskets) |> filter(id: basket_id)
    basket = Moebius.Db.first(basket_query)
    case basket do
      nil ->
        {:error, :not_found}
      basket ->
      purchases_query = db(:purchases)
      |> filter(shopping_basket_id: basket_id)
      purchases = Moebius.Db.run(purchases_query)
      purchases = Enum.map(purchases, fn
        (purchase = %{item_id: item_id}) ->
          query = db(:items) |> filter(id: item_id)
          item = Moebius.Db.first(query)
          {item.id, Map.merge(purchase, %{item: item})}
      end)
      |> Enum.into(%{})
      {:ok, Map.merge(basket, %{purchases: purchases})}
    end
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(Moebius.Db, [Moebius.get_connection]),
    ]

    opts = [strategy: :one_for_one, name: UM.Sales.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
