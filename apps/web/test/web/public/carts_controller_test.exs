defmodule UM.Web.CartsControllerTest do
  use ExUnit.Case
  import Raxx.Request

  alias UM.Web.CartsController, as: Controller

  setup do
    :ok = UM.Accounts.Fixtures.clear_db
    :ok = UM.Sales.Fixtures.clear_db
    :ok = UM.Catalogue.Fixtures.clear_db
    garden_tiger = UM.Catalogue.Fixtures.garden_tiger
    {:ok, %{piece: garden_tiger}}
  end

  test "guest can view their cart" do
    {:ok, record} = UM.Sales.create_shopping_basket
    {:ok, record} = UM.Sales.edit_purchases(record, %{"garden-audio-part" => 3})
    {:ok, cart} = UM.Sales.CartsRepo.fetch_by_id(record.id)
    session = UM.Web.Session.new |> UM.Web.Session.update_shopping_basket(cart)
    request = get("/#{cart.id}", [{"um-session", session}])
    response = Controller.handle_request(request, [])
    assert 200 == response.status
  end

  # test that the session is updated with the correct cart.
  # test that the cart is updated in the database.
  # test that the user is redirected to the correct cart.
  # test that the correct flash message is set.
  test "guest can add a purchase to new cart" do
    request = patch("/__empty__/purchases", Raxx.Test.form_data(%{
      "purchases" => %{
        "garden-all-parts" => "1"
      }
    }), [{"um-session", UM.Web.Session.new}])
    response = Controller.handle_request(request, [])

    request_2 = Raxx.Patch.follow(response)
    assert ["shopping_baskets", basket_id] = request_2.path
    session = :proplists.get_value("um-set-session", response.headers)
    assert basket_id == UM.Web.Session.cart(session).id
    # {%{success: "Items added to cart"}, _request} = UM.Web.Flash.from_request(request_2)
    {:ok, basket} = UM.Sales.CartsRepo.fetch_by_id(basket_id)
    assert 1 == UM.Sales.Cart.number_of_lines(basket)
    assert 1 == UM.Sales.Cart.number_of_units(basket)
  end

  test "guest can add a purchase to existing cart" do
    {:ok, cart} = UM.Sales.create_shopping_basket
    {:ok, cart} = UM.Sales.edit_purchases(cart, %{"garden-audio-part" => 3})
    session = UM.Web.Session.new |> UM.Web.Session.update_shopping_basket(cart)

    request = patch("/#{cart.id}/purchases", Raxx.Test.form_data(%{
      "purchases" => %{
        "garden-all-parts" => "1",
        "garden-audio-part" => "1"
      }
    }), [{"um-session", session}])
    response = Controller.handle_request(request, [])

    request_2 = Raxx.Patch.follow(response)
    assert ["shopping_baskets", basket_id] = request_2.path
    session = :proplists.get_value("um-set-session", response.headers)
    assert basket_id == UM.Web.Session.cart(session).id
    # {%{success: "Items added to basket"}, _request} = UM.Web.Flash.from_request(request_2)
    {:ok, basket} = UM.Sales.CartsRepo.fetch_by_id(basket_id)
    assert 2 == UM.Sales.Cart.number_of_lines(basket)
    assert 2 == UM.Sales.Cart.number_of_units(basket)
  end

  test "customer can add a purchase to new cart" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = patch("/__empty__/purchases", Raxx.Test.form_data(%{
      "purchases" => %{
        "garden-all-parts" => "1"
      }
    }), [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = Controller.handle_request(request, [])
    request_2 = Raxx.Patch.follow(response)
    assert ["shopping_baskets", basket_id] = request_2.path
    session = :proplists.get_value("um-set-session", response.headers)
    assert basket_id == UM.Web.Session.cart(session).id
    {:ok, updated_jo} = UM.Accounts.CustomersRepo.fetch_by_id(jo.id)
    assert basket_id == updated_jo.shopping_basket_id
    {:ok, cart} = UM.Sales.CartsRepo.fetch_by_id(basket_id)
    assert 1 == UM.Sales.Cart.number_of_lines(cart)
    assert 1 == UM.Sales.Cart.number_of_units(cart)
  end

  test "customer can checkout their cart" do
    _ = UM.Catalogue.Fixtures.garden_tiger
    {:ok, record} = UM.Sales.create_shopping_basket
    {:ok, record} = UM.Sales.edit_purchases(record, %{"garden-audio-part" => 3})
    jo = UM.Accounts.Fixtures.jo_brand
    {:ok, jo} = UM.Accounts.update_customer(%{jo | shopping_basket_id: record.id})
    session = UM.Web.Session.new |> UM.Web.Session.login(jo)
    request = post("/#{record.id}/checkout", [{"um-session", session}])
    response = Controller.handle_request(request, [])
    request_2 = Raxx.Patch.follow(response)
    assert ["orders", order_id] = request_2.path
    {:ok, order} = UM.Sales.Orders.fetch_by_id(order_id)
    assert order.state == "pending"
    assert order.currency == "GBP"
    assert order.customer_id == jo.id
    assert order.cart_total == 120
  end
end
