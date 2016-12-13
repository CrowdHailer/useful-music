defmodule UM.Web.OrdersControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Catalogue
  alias UM.Web.OrdersController, as: Controller

  setup do
    :ok = UM.Web.Fixtures.clear_db
    garden_tiger = UM.Web.Fixtures.garden_tiger
    {:ok, %{piece: garden_tiger}}
  end

  test "customer can add a purchase to their basket" do
    {:ok, basket} = UM.Sales.create_shopping_basket
    # TODO have items in already
    request = post("/#{basket.id}/items", form_data(%{
      "items" => %{
        "garden-all-parts" => "4",
        "garden-flute-part" => "2"
      }
    }), UM.Web.Session.customer_session(%{id: "100"}))

    response = Controller.handle_request(request, [])
    request_2 = Raxx.Patch.follow(response)
    assert ["shopping_baskets", basket.id] == request_2.path
    {%{success: "Items added to basket"}, _request} = UM.Web.Flash.from_request(request_2)
    {:ok, basket} = UM.Sales.fetch_shopping_basket(basket.id)
    assert 2 == UM.Sales.ShoppingBasket.number_of_purchases(basket)
    assert 6 == UM.Sales.ShoppingBasket.number_of_licences(basket)
  end

  test "guest can add a purchase to new basket" do
    request = post("/empty/items", form_data(%{
      "items" => %{
        "garden-all-parts" => "1"
      }
    }), UM.Web.Session.guest_session)

    response = Controller.handle_request(request, [])
    request_2 = Raxx.Patch.follow(response)
    assert ["shopping_baskets", basket_id] = request_2.path
    {%{success: "Items added to basket"}, _request} = UM.Web.Flash.from_request(request_2)
    {:ok, basket} = UM.Sales.fetch_shopping_basket(basket_id)
    assert 1 == UM.Sales.ShoppingBasket.number_of_purchases(basket)
    assert 1 == UM.Sales.ShoppingBasket.number_of_licences(basket)
  end

  @tag :skip
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

  @tag :skip
  test "can delete items from basket", %{piece: %{id: piece_id}} do
    {:ok, %{items: [%{id: item_id}]}} = Catalogue.load_items(%{id: piece_id})
    {:ok, basket} = UM.Sales.create_shopping_basket
    request = delete("/#{basket.id}/items/#{item_id}", UM.Web.Session.customer_session(%{id: "100"}))
    response = Controller.handle_request(request, [])
  end
end
