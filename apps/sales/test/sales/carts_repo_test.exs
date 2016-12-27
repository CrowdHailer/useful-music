# defmodule UM.Sales.CartsRepoTest do
#   use ExUnit.Case
#   alias UM.Sales.{Cart, CartsRepo}
#
#   setup do
#     :ok = UM.Sales.Fixtures.clear_db
#   end
#
#   test "can fetch a saved cart" do
#     %{id: id} = UM.Sales.Fixtures.guest_cart
#     {:ok, cart} = CartsRepo.fetch_by_id(id)
#   end
# end
