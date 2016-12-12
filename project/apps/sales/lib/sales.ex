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
        {:ok, struct(UM.Sales.ShoppingBasket, record)}
    end
  end

  def add_purchases(basket, purchases) do
      add_purchases(basket, purchases, [])
  end
  def add_purchases(basket, [], added) do
    {:ok, %{basket | purchases: Enum.reverse(added)}}
  end
  def add_purchases(basket, [purchase | rest], added) do
    case add_purchase(basket, purchase) do
      record = %{id: id} ->
        add_purchases(basket, rest, [record | added])
    end
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
    update = case Moebius.Db.run(query) do
      [] ->
        db(:purchases)
        |> insert(shopping_basket_id: basket_id, item_id: item_id, quantity: quantity, id: random_string(16))
    end
    Moebius.Db.run(update)
  end

  def fetch_shopping_basket(basket_id) do
    basket_query = db(:shopping_baskets) |> filter(id: basket_id)
    basket = Moebius.Db.first(basket_query)
    purchases_query = db(:purchases)
    |> filter(shopping_basket_id: basket_id)
    purchases = Moebius.Db.run(purchases_query)
    {:ok, Map.merge(basket, %{purchases: purchases})}
  end

  def add_purchase(%{id: basket_id}, %{quantity: quantity, item_id: item_id}) do
    query = db(:purchases)
    |> filter(shopping_basket_id: basket_id, item_id: item_id)
    case Moebius.Db.run(query) do
      [] ->
        db(:purchases)
        |> insert(shopping_basket_id: basket_id, item_id: item_id, quantity: quantity, id: random_string(16))
      [%{id: id}] ->
        IO.inspect(id)
        db(:purchases)
        |> filter(id: id)
        |> update(quantity: quantity)
    end
    # |> update()
    |> Moebius.Db.run
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
