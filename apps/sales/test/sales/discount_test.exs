defmodule UM.Sales.DiscountTest do
  use ExUnit.Case
  alias UM.Sales.Discount

  test "null discount is worthless" do
    assert 0 == Discount.value(Discount.zero)
  end

  test "null discount is always available" do
    assert {:ok, Discount.zero} == Discount.check_availabile(Discount.zero, Timex.Date.now)
  end

  # Not sure what the id (nil)? and code ("__ZERO__")? of the null discount should be.
end
