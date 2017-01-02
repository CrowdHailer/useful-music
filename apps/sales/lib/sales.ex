defmodule UM.Sales do
  use Application
  import Moebius.Query

  def create_shopping_basket do
    query = db(:shopping_baskets) |> insert(id: Utils.random_string(16))
    case Moebius.Db.run(query) do
      {:error, reason} ->
        IO.inspect(reason)
        {:error, reason}
      record ->
        {:ok, struct(UM.Sales.Cart, record)}
    end
  end

  def edit_purchases(cart, purchases) do
    cart = case cart do
      %{id: nil} ->
        {:ok, cart} = create_shopping_basket
        cart
      cart ->
        cart
    end
    purchases |> Enum.map(fn
      ({item_id, quantity}) ->
        UM.Sales.set_item(cart.id, item_id, quantity: quantity)
    end)
    UM.Sales.CartsRepo.fetch_by_id(cart.id)
  end

  def set_item(basket_id, item_id, opts \\ []) do
    opts = Enum.into(opts, %{})
    quantity = Map.get(opts, :quantity, 1)
    query = db(:purchases)
    |> filter(shopping_basket_id: basket_id, item_id: item_id)
    update = case {Moebius.Db.run(query), quantity} do
      {[], q} ->
        db(:purchases)
        |> insert(shopping_basket_id: basket_id, item_id: item_id, quantity: quantity, id: Utils.random_string(16))
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

  def apply_discount_code(cart, "") do
    action = db(:shopping_baskets) |> filter(id: cart.id) |> update(discount_id: nil)
    case Moebius.Db.run(action) do
      {:error, reason} ->
        {:error, reason}
      cart ->
        {:ok, cart}
    end
  end
  def apply_discount_code(cart, discount_code) do
    case UM.Sales.DiscountsRepo.fetch_available_code(discount_code) do
      {:ok, %{id: discount_id}} ->
        action = db(:shopping_baskets) |> filter(id: cart.id) |> update(discount_id: discount_id)
        case Moebius.Db.run(action) do
          {:error, reason} ->
            {:error, reason}
          cart ->
            {:ok, cart}
        end
      {:error, :not_found} ->
        {:error, :unknown_discount_code}
    end
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
