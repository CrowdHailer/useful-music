defmodule UM.Catalogue.ItemTest do
  use ExUnit.Case
  alias UM.Catalogue.Item

  test "calculates price for single item" do
    item = %Item{initial_price: Money.new(100, :GBP)}
    assert Money.new(100, :GBP) == Item.price_for(item, 1)
  end

  test "calculates price for several items without discount" do
    item = %Item{initial_price: Money.new(100, :GBP)}
    assert Money.new(300, :GBP) == Item.price_for(item, 3)
  end

  test "calculates price for several items with discount" do
    item = %Item{initial_price: Money.new(100, :GBP), discounted_price: Money.new(50, :GBP)}
    assert Money.new(200, :GBP) == Item.price_for(item, 3)
  end
end
