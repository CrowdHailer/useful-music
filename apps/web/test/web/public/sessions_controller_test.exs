defmodule UM.Web.SessionsControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Web.SessionsController

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  @tag :skip
  test "login page redirects if already logged in" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/sessions/new", UM.Web.Session.external_session(%{customer_id: jo.id}))
    response = UM.Web.handle_request(request, :no_state)
    assert 302 == response.status
    assert "/customers/#{jo.id}" == Raxx.Patch.response_location(response)
  end

  @tag :skip
  test "redirects to account page if already logged it" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/new", UM.Web.Session.customer_session(jo))
    response = SessionsController.handle_request(request, :nostate)
    assert 302 == response.status
    assert "/customers/#{jo.id}" == Raxx.Patch.response_location(response)
  end

  # login from checkout page with a guest basket
    @tag :skip
  test "login will add user id to session" do
    jo = UM.Web.Fixtures.jo_brand
    basket = UM.Web.Fixtures.guest_basket
    request = post("/sessions", encode_form(%{
      target: "/checkout",
      session: %{email: jo.email, password: jo.password}
    }), UM.Web.Session.external_session(%{shopping_basket_id: basket.id}))
    response = UM.Web.handle_request(request, :no_state)
    assert delivered_cookies = :proplists.get_value("set-cookie", response.headers)
    assert "raxx.session=" <> encoded_session = delivered_cookies
    {:ok, %{customer_id: id}} = UM.Web.Session.decode(encoded_session)
    assert id == jo.id
    assert ["checkout"] == Raxx.Patch.follow(response).path
    # TODO guest shopping basket is added to the customer record
    # TODO guest shopping basket is added to the session
  end

  @tag :skip
  test "login with invalid credentials shows flash" do
    request = post("/sessions", encode_form(%{
      session: %{email: "interloper@example.com", password: "bad_password"}
    }))
    response = UM.Web.handle_request(request, :no_state)
    request = Raxx.Patch.follow(response)
    assert {%{error: "Invalid login details"}, _} = UM.Web.Flash.from_request(request)
  end

  @tag :skip
  # TODO packing and unpacking session
  test "logout will delete session" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = post("/sessions", %{
      body: "_method=DELETE",
      headers: [{"content-type", "application/x-www-form-urlencoded"}]
    }, UM.Web.Session.external_session(%{customer_id: bugs.id}))
    response = UM.Web.handle_request(request, :no_state)
    assert 303 == response.status
    # TODO check cookies
  end

  @tag :skip
  test "login page (/sessions/new) maintains the users target" do
    request = get({"/new", %{"target" => "/admin"}}, UM.Web.Session.guest_session)
    response = SessionsController.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "name=\"requested_path\" value=\"/admin\"")
  end

  @tag :skip
  test "logging in sends user to their orders page" do
    jo = UM.Web.Fixtures.jo_brand
    request = post("/", %{
      "session" => %{"email" => jo.email, "password" => jo.password}
    })
    response = SessionsController.handle_request(request, :nostate)
    assert 302 == response.status
    assert "/customers/#{jo.id}" == Raxx.Patch.response_location(response)
    # DEBT test encoded session.
  end
end
