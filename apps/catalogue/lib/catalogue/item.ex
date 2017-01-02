defmodule UM.Catalogue.Item do
  defstruct [
    id: nil,
    name: nil,
    initial_price: nil,
    discounted_price: nil,
    asset: nil,
    piece_id: nil
  ]

  def price_for(item, n) when is_integer(n) and n > 0 do
    Money.add(item.initial_price, Money.multiply(subsequent_price(item), (n-1)))
  end

  def initial_price(%{initial_price: i}) do
    i
  end

  def subsequent_price(%{initial_price: i, discounted_price: d}) do
    d || i
  end

  def multibuy_discount?(item) do
    !!item.discounted_price
  end
end
