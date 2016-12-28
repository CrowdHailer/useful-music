defmodule UM.Web.SessionTest do
  use ExUnit.Case
  import Raxx.Request
  alias UM.Web.Session

  setup do
    :ok = UM.Accounts.Fixtures.clear_db
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  ##### AUTHORIZATION

  test "guest session is not logged in and cannot view admin pages" do
    session = Session.new()
    assert false == Session.logged_in?(session)
    assert false == Session.admin?(session)
  end

  test "customer session is logged in and cannot view admin pages" do
    jo = UM.Accounts.Fixtures.jo_brand
    session = Session.new() |> Session.login(jo)
    assert true == Session.logged_in?(session)
    assert false == Session.admin?(session)
  end

  test "admin session is logged in and can view admin pages" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    session = Session.new() |> Session.login(bugs)
    assert true == Session.logged_in?(session)
    assert true == Session.admin?(session)
  end

  test "guest session cannot view customer account" do
    jo = UM.Accounts.Fixtures.jo_brand
    session = Session.new()
    assert false == Session.can_view_account?(session, jo.id)
  end

  test "customer can view their own accounts only" do
    jo = UM.Accounts.Fixtures.jo_brand
    bugs = UM.Accounts.Fixtures.bugs_bunny
    session = Session.new() |> Session.login(jo)
    assert true == Session.can_view_account?(session, jo.id)
    assert false == Session.can_view_account?(session, bugs.id)
  end

  test "admin can view all customer accounts" do
    jo = UM.Accounts.Fixtures.jo_brand
    bugs = UM.Accounts.Fixtures.bugs_bunny
    session = Session.new() |> Session.login(bugs)
    assert true == Session.can_view_account?(session, jo.id)
    assert true == Session.can_view_account?(session, bugs.id)
  end

  ### CURRENCY PREFERENCES

  test "new session has GBP currency_preference" do
    session = Session.new()
    assert "GBP" == Session.currency_preference(session)
  end

  test "guest can select currency preference" do
    session = Session.new |> Session.select_currency("EUR")
    assert "EUR" == Session.currency_preference(session)
  end

  test "customer selecting a currency preference will have it saved" do
    jo = UM.Accounts.Fixtures.jo_brand
    session = Session.new
    |> Session.login(jo)
    |> Session.select_currency("GBP")
    assert "GBP" == Session.currency_preference(session)
    {:ok, updated_jo} = UM.Accounts.fetch_by_id(jo.id)
    assert "GBP" == updated_jo.currency_preference
  end

  test "logging in will select the users currency preference, if they have one" do
    jo = UM.Accounts.Fixtures.jo_brand
    session = Session.new |> Session.login(jo)
    assert "USD" == Session.currency_preference(session)
  end

  test "logging in set the users currency preference, if the do not have one" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    session = Session.new |> Session.select_currency("EUR") |> Session.login(bugs)
    {:ok, updated_bugs} = UM.Accounts.fetch_by_id(bugs.id)
    assert "EUR" == updated_bugs.currency_preference
  end

  ### SHOPPING ACTIONS

  test "new session has an empty basket" do
    session = Session.new()
    assert UM.Sales.Cart.empty == Session.cart(session)
  end

  test "guest can update their cart" do
    {:ok, cart} = UM.Sales.create_shopping_basket
    session = Session.new |> Session.update_shopping_basket(cart)
    assert cart == Session.cart(session)
  end

  test "customer updating their cart will have it saved" do
    jo = UM.Accounts.Fixtures.jo_brand
    {:ok, cart} = UM.Sales.create_shopping_basket
    session = Session.new
    |> Session.login(jo)
    |> Session.update_shopping_basket(cart)
    assert cart == Session.cart(session)
    {:ok, updated_jo} = UM.Accounts.fetch_by_id(jo.id)
    assert cart.id == updated_jo.shopping_basket_id
  end

  test "logging in uses customer cart if session cart empty" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    _ = UM.Catalogue.Fixtures.garden_tiger
    {:ok, record} = UM.Sales.create_shopping_basket
    {:ok, record} = UM.Sales.edit_purchases(record, %{"garden-audio-part" => 3})
    {:ok, cart} = UM.Sales.CartsRepo.fetch_by_id(record.id)
    {:ok, bugs} = UM.Accounts.update_customer(%{bugs | shopping_basket_id: cart.id})
    session = Session.new
    |> Session.login(bugs)
    {:ok, latest_bugs} = UM.Accounts.fetch_by_id(bugs.id)
    assert Session.cart(session).id == latest_bugs.shopping_basket_id
  end

  test "logging in uses session cart if customer cart empty, and sets customers current cart" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    _ = UM.Catalogue.Fixtures.garden_tiger
    {:ok, record} = UM.Sales.create_shopping_basket
    {:ok, record} = UM.Sales.edit_purchases(record, %{"garden-audio-part" => 3})
    {:ok, cart} = UM.Sales.CartsRepo.fetch_by_id(record.id)
    session = Session.new
    |> Session.update_shopping_basket(cart)
    |> Session.login(bugs)
    {:ok, latest_bugs} = UM.Accounts.fetch_by_id(bugs.id)
    assert Session.cart(session).id == latest_bugs.shopping_basket_id
  end

  test "carry on shopping with session cart if it has items, the old cart will be abandoned" do

  end
end
