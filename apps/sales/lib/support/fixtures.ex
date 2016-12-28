defmodule UM.Sales.Fixtures do
  import Moebius.Query

  def clear_db do
    db(:orders) |> delete |> Moebius.Db.run
    db(:discounts) |> delete |> Moebius.Db.run
    db(:shopping_baskets) |> delete |> Moebius.Db.run
    :ok
  end


  def guest_basket do
    basket = db(:shopping_baskets) |> insert(id: "inprogress-shop")
    |> Moebius.Db.run
    UM.Catalogue.Fixtures.garden_tiger
    UM.Sales.set_item(basket.id, "garden-flute-part")
    UM.Sales.set_item(basket.id, "garden-all-parts")
    basket
  end

  def current_discount() do
    db(:discounts)
    |> insert(
    id: "test-code",
    code: "NOW123",
    value: 1000,
    allocation: 10,
    customer_allocation: 1,
    start_datetime: {{2016, 1, 1}, {0, 0, 0}},
    end_datetime: {{2020, 1, 1}, {0, 0, 0}},
    )
    |> Moebius.Db.run
  end

  def pending_discount() do
    db(:discounts)
    |> insert(
    id: "test-code",
    code: "FUTURE123",
    value: 1000,
    allocation: 10,
    customer_allocation: 1,
    start_datetime: {{2020, 1, 1}, {0, 0, 0}},
    end_datetime: {{2021, 1, 1}, {0, 0, 0}},
    )
    |> Moebius.Db.run
  end

  def expired_discount() do
    db(:discounts)
    |> insert(
    id: "test-code",
    code: "PAST123",
    value: 1000,
    allocation: 10,
    customer_allocation: 1,
    start_datetime: {{2015, 1, 1}, {0, 0, 0}},
    end_datetime: {{2016, 1, 1}, {0, 0, 0}},
    )
    |> Moebius.Db.run
  end
end
