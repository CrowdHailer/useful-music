defmodule UM.Web.SessionTest do
  use ExUnit.Case
  import Raxx.Request
  alias UM.Web.Session

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  ##### AUTHORIZATION

  test "guest session is not logged in and cannot view admin pages" do
    session = Session.new()
    assert false == Session.logged_in?(session)
    assert false == Session.admin?(session)
  end

  test "customer session is logged in and cannot view admin pages" do
    jo = UM.Web.Fixtures.jo_brand
    session = Session.new() |> Session.login(jo)
    assert true == Session.logged_in?(session)
    assert false == Session.admin?(session)
  end

  test "admin session is logged in and cannot view admin pages" do
    bugs = UM.Web.Fixtures.bugs_bunny
    session = Session.new() |> Session.login(bugs)
    assert true == Session.logged_in?(session)
    assert true == Session.admin?(session)
  end

  test "guest session cannot view customer account" do
    jo = UM.Web.Fixtures.jo_brand
    session = Session.new()
    assert false == Session.can_view_account?(session, jo.id)
  end

  test "customer can view their own accounts only" do
    jo = UM.Web.Fixtures.jo_brand
    bugs = UM.Web.Fixtures.bugs_bunny
    session = Session.new() |> Session.login(jo)
    assert true == Session.can_view_account?(session, jo.id)
    assert false == Session.can_view_account?(session, bugs.id)
  end

  test "admin can view all customer accounts" do
    jo = UM.Web.Fixtures.jo_brand
    bugs = UM.Web.Fixtures.bugs_bunny
    session = Session.new() |> Session.login(bugs)
    assert true == Session.can_view_account?(session, jo.id)
    assert true == Session.can_view_account?(session, bugs.id)
  end

  ### CURRENCY PREFERENCES

  test "new session has GBP currency_preference" do
    session = Session.new()
    assert "GBP" == Session.currency_preference(session)
  end

  test "select currency preference" do
    session = Session.new |> Session.select_currency("EUR")
    assert "EUR" == Session.currency_preference(session)
  end

  test "selecting a currency will save it to the customers data" do
    jo = UM.Web.Fixtures.jo_brand
    session = Session.new
    |> Session.login(jo)
    |> Session.select_currency("GBP")
    assert "GBP" == Session.currency_preference(session)
    {:ok, updated_jo} = UM.Accounts.fetch_by_id(jo.id)
    assert "GBP" == updated_jo.currency_preference
  end

  test "logging in will select the users currency preference, if they have one" do
    jo = UM.Web.Fixtures.jo_brand
    session = Session.new |> Session.login(jo)
    assert "USD" == Session.currency_preference(session)
  end

  test "logging in set the users currency preference, if the do not have one" do
    bugs = UM.Web.Fixtures.bugs_bunny
    session = Session.new |> Session.select_currency("EUR") |> Session.login(bugs)
    {:ok, updated_bugs} = UM.Accounts.fetch_by_id(bugs.id)
    assert "EUR" == updated_bugs.currency_preference
  end

  ### SHOPPING ACTIONS

  test "new session has an empty basket" do
    session = Session.new()
    assert 0 == Session.checkout_price(session)
    assert 0 == Session.number_of_basket_items(session)
  end

  test "logging in uses customer basket if session basket empty" do

  end

  test "logging in uses session basket if customer basket empty" do

  end

  test "carry on shopping with session basket if it has items, the old basket will be abandoned" do

  end
end
