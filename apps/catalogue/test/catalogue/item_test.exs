defmodule UM.Catalogue.ItemTest do
  use ExUnit.Case
  alias UM.Catalogue.Item

  test "calculates price for single item" do
    item = %Item{initial_price: 100}
    assert 100 = Item.price_for(item, 1)
  end

  test "calculates price for several items without discount" do
    item = %Item{initial_price: 100}
    assert 300 = Item.price_for(item, 3)
  end

  test "calculates price for several items with discount" do
    item = %Item{initial_price: 100, discounted_price: 50}
    assert 200 = Item.price_for(item, 3)
  end
end
