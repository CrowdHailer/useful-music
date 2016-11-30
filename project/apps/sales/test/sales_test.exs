defmodule UM.SalesTest do
  use ExUnit.Case
  alias UM.Sales

  import Moebius.Query
  @tag :skip
  test "Can start a new basket" do
    # Same as creating a new shopping basket / order.
    # Shopping basket is just a pending order.
    # NOTE shopping basket has many orders because an order can fail.
    # Can just create new order if failed but the domain has a concept of a basket so we will use it.
    {:ok, basket = %{id: id}} = Sales.create_shopping_basket()
    assert Sales.ShoppingBasket.empty?(basket)
  end

  test "A successful shopping trip" do
    # Replace this with some fixtures however set up.
    # %{id: id} = create_piece()
    # %{id: id} = create_item(100)
    [%{id: item_id_1}, %{id: item_id_2} | _] = Moebius.Query.db(:items) |> Moebius.Db.run

    {:ok, basket = %{id: basket_id}} = Sales.create_shopping_basket()
    assert Sales.ShoppingBasket.empty?(basket)

    {:ok, basket} = Sales.add_purchases(basket, [%{quantity: 2, item_id: item_id_1}])
    {:ok, basket} = Sales.add_purchases(basket, [%{quantity: 3, item_id: item_id_1}, %{quantity: 1, item_id: item_id_2}])

    refute Sales.ShoppingBasket.empty?(basket)
  end

  def create_piece do
    Moebius.Query.db(:pieces)
    |> Moebius.Query.insert([
      id: 100,
      title: "Canonical",
      sub_heading: "The very first piece",
      description: "I uses this piece for testing all the flipping time",
      level_overview: "not that easy",
      notation_preview: "A link which I don't yet have"
      ])
    |> Moebius.Db.run
  end

  def create_item(piece_id) do
    Moebius.Query.db(:items)
    |> Moebius.Query.insert([
      id: random_string(16),
      name: "the other piece",
      initial_price: 60,
      asset: "link I dont have again",
      piece_id: piece_id
    ])
    |> Moebius.Db.run
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
