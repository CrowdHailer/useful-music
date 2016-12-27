defmodule UM.Sales.CartsRepoTest do
  use ExUnit.Case
  alias UM.Sales.{Cart, CartsRepo}

  setup do
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  test "can fetch a saved cart" do
    _ = UM.Catalogue.Fixtures.garden_tiger
    {:ok, record} = UM.Sales.create_shopping_basket
    {:ok, record} = UM.Sales.edit_purchases(record, %{"garden-audio-part" => 3})
    {:ok, cart} = CartsRepo.fetch_by_id(record.id)
    assert cart.id == record.id
    assert 3 == Cart.number_of_units(cart)
    assert 1 == Cart.number_of_lines(cart)
  end
end
