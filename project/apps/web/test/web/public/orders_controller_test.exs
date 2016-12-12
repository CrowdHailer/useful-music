defmodule UM.Web.OrdersControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Catalogue
  alias UM.Web.OrdersController, as: Controller

  setup do
    Moebius.Query.db(:purchases) |> Moebius.Query.delete |> Moebius.Db.run
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run

    {:ok, _item} = Catalogue.load_fixtures
    {:ok, %{piece: %{id: 101}}}
  end

  # DEBT nest under /shopping_baskets/id
  test "can create a new purchase", %{piece: %{id: piece_id}} do
    {:ok, %{items: [%{id: item_id}]}} = Catalogue.load_items(%{id: piece_id})
    {:ok, basket} = UM.Sales.create_shopping_basket
    request = post("/#{basket.id}/items", form_data(%{
      "items" => %{
        item_id => "4"
      }
    }), UM.Web.Session.customer_session(%{id: "100"}))
    response = Controller.handle_request(request, [])
    request_2 = Raxx.Patch.follow(response)
    assert ["shopping_baskets", basket.id] == request_2.path
    {%{success: "Items added to basket"}, _request} = UM.Web.Flash.from_request(request_2)
    {:ok, _basket} = UM.Sales.fetch_shopping_basket(basket.id)
    |> IO.inspect
    # TODO check that the basket is correctly updated
  end

  test "can update the number of items", %{piece: %{id: piece_id}} do
    {:ok, %{items: [%{id: item_id}]}} = Catalogue.load_items(%{id: piece_id})
    {:ok, basket} = UM.Sales.create_shopping_basket
    request = put("/#{basket.id}/items/#{item_id}", form_data(%{
      "item" => %{
        "quantity" => "2"
      }
    }), UM.Web.Session.customer_session(%{id: "100"}))
    response = Controller.handle_request(request, [])
    |> IO.inspect
  end

  test "can delete items from basket", %{piece: %{id: piece_id}} do
    {:ok, %{items: [%{id: item_id}]}} = Catalogue.load_items(%{id: piece_id})
    {:ok, basket} = UM.Sales.create_shopping_basket
    request = delete("/#{basket.id}/items/#{item_id}", UM.Web.Session.customer_session(%{id: "100"}))
    response = Controller.handle_request(request, [])
  end
end
