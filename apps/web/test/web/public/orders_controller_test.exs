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

  @tag :skip
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
    assert ["orders", basket.id] == request_2.path
    {%{success: "Items added to basket"}, _request} = UM.Web.Flash.from_request(request_2)
    {:ok, basket} = UM.Sales.fetch_shopping_basket(basket.id)
    assert 2 == UM.Sales.Basket.number_of_lines(basket)
    assert 6 == UM.Sales.Basket.number_of_units(basket)
  end

  test "guest can add a purchase to new basket" do
    request = post("/empty/items", form_data(%{
      "items" => %{
        "garden-all-parts" => "1"
      }
    }), UM.Web.Session.guest_session)

    response = Controller.handle_request(request, [])
    request_2 = Raxx.Patch.follow(response)
    assert ["orders", basket_id] = request_2.path
    # {%{success: "Items added to basket"}, _request} = UM.Web.Flash.from_request(request_2)
    {:ok, basket} = UM.Sales.fetch_shopping_basket(basket_id)
    assert 1 == UM.Sales.Basket.number_of_lines(basket)
    assert 1 == UM.Sales.Basket.number_of_units(basket)
  end

  @tag :skip
  test "can update the number of items" do
    {:ok, basket} = UM.Sales.create_shopping_basket
    item_id = "garden-flute-part"
    UM.Sales.add_item(basket.id, item_id, quantity: 3)
    request = put("/#{basket.id}/items/#{item_id}", form_data(%{
      "item" => %{
        "quantity" => "2"
      }
    }), UM.Web.Session.customer_session(%{id: "100"}))
    response = Controller.handle_request(request, [])
    assert 302 == response.status
    {:ok, basket} = UM.Sales.fetch_shopping_basket(basket.id)
    assert 1 == UM.Sales.Basket.number_of_lines(basket)
    assert 2 == UM.Sales.Basket.number_of_units(basket)
  end

  @tag :skip
  test "can delete items from basket" do
    {:ok, basket} = UM.Sales.create_shopping_basket
    item_id = "garden-flute-part"
    UM.Sales.add_item(basket.id, item_id, quantity: 3)
    request = delete("/#{basket.id}/items/#{item_id}", UM.Web.Session.customer_session(%{id: "100"}))
    response = Controller.handle_request(request, [])
    assert 302 == response.status
    {:ok, basket} = UM.Sales.fetch_shopping_basket(basket.id)
    assert 0 == UM.Sales.Basket.number_of_lines(basket)
    assert 0 == UM.Sales.Basket.number_of_units(basket)
  end
end
