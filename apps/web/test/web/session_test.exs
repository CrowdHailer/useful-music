defmodule UM.Web.SessionTest do
  use ExUnit.Case
  import Raxx.Request
  alias UM.Web.Session

  setup do
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
    assert UM.Sales.Cart.empty == Session.shopping_basket(session)
  end

  test "guest can update their shopping basket" do
    {:ok, shopping_basket} = UM.Sales.create_shopping_basket
    session = Session.new |> Session.update_shopping_basket(shopping_basket)
    assert shopping_basket == Session.shopping_basket(session)
  end

  test "customer updating their shopping basket will have it saved" do
    jo = UM.Accounts.Fixtures.jo_brand
    {:ok, shopping_basket} = UM.Sales.create_shopping_basket
    session = Session.new
    |> Session.login(jo)
    |> Session.update_shopping_basket(shopping_basket)
    assert shopping_basket == Session.shopping_basket(session)
    {:ok, updated_jo} = UM.Accounts.fetch_by_id(jo.id)
    assert shopping_basket.id == updated_jo.shopping_basket_id
  end

  test "logging in uses customer basket if session basket empty" do

  end

  test "logging in uses session basket if customer basket empty" do

  end

  test "carry on shopping with session basket if it has items, the old basket will be abandoned" do

  end
end
