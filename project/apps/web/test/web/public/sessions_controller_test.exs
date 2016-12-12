defmodule UM.Web.SessionsControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Web.SessionsController

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  test "login page (/sessions/new) maintains the users target" do
    request = get({"/new", %{"target" => "/admin"}}, UM.Web.Session.guest_session)
    response = SessionsController.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "name=\"requested_path\" value=\"/admin\"")
  end

  test "redirects to account page if already logged it" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/new", UM.Web.Session.customer_session(jo))
    response = SessionsController.handle_request(request, :nostate)
    assert 302 == response.status
    assert "/customers/#{jo.id}" == Raxx.Patch.response_location(response)
  end

  test "logging in sends user to their orders page" do
    jo = UM.Web.Fixtures.jo_brand
    request = post("/", %{
      "session" => %{"email" => jo.email, "password" => jo.password}
    })
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/customers/#{jo.id}" == Raxx.Patch.response_location(response)
    # DEBT test encoded session.
  end

  test "loggin in will redirect to the target if given" do
    jo = UM.Web.Fixtures.jo_brand
    request = post("/", %{
      "session" => %{"email" => jo.email, "password" => jo.password},
      "target" => "/admin"
    })
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/admin" == Raxx.Patch.response_location(response)
  end

  test "redirect to login page if invalid credentials" do
    request = post("/", form_data(%{
      "session" => %{"email" => "bob@g.co", "password" => "not a password"}
    }))
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/sessions/new" <> _ = Raxx.Patch.response_location(response)
  end

  test "log out will destroy session" do
    jo = UM.Web.Fixtures.jo_brand
    request = delete("/", UM.Web.Session.customer_session(jo))
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/" = Raxx.Patch.response_location(response)
    set_cookies(response)
    # |> IO.inspect
  end

  def set_cookies(_response = %{headers: headers}) do
    headers
    # DEBT expire cookies
  end
end
