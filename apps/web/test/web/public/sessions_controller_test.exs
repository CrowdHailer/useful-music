defmodule UM.Web.SessionsControllerTest do
  use ExUnit.Case
  import Raxx.Request

  alias UM.Web.SessionsController

  setup do
    :ok = UM.Accounts.Fixtures.clear_db
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  def external_session(session) do
    [{"cookie", "raxx.session=" <> UM.Web.Session.encode!(session)}]
  end

  test "login page redirects if already logged in" do
    jo = UM.Accounts.Fixtures.jo_brand
    session = UM.Web.Session.new |> UM.Web.Session.login(jo)
    request = get("/sessions/new", external_session(session))
    response = UM.Web.handle_request(request, :no_state)
    assert 302 == response.status
    assert "/customers/#{jo.id}" == Raxx.Patch.response_location(response)
  end

  test "login with invalid credentials shows flash" do
    request = post("/sessions", Raxx.Test.encode_form(%{
      session: %{email: "interloper@example.com", password: "bad_password"}
    }))
    response = UM.Web.handle_request(request, :no_state)
    request = Raxx.Patch.follow(response)
    assert {%{error: "Invalid login details"}, _} = UM.Web.Flash.from_request(request)
  end

  test "logout will delete session" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    request = post("/sessions", %{
      body: "_method=DELETE",
      headers: [{"content-type", "application/x-www-form-urlencoded"}]
    }, external_session(UM.Web.Session.new |> UM.Web.Session.login(bugs)))
    response = UM.Web.handle_request(request, :no_state)
    assert 302 == response.status
  end

  test "login page (/sessions/new) maintains the users target" do
    request = get({"/new", %{"target" => "/admin"}}, [{"um-session", UM.Web.Session.new}])
    response = SessionsController.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "name=\"requested_path\" value=\"/admin\"")
  end

  test "logging in sends user to their orders page" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = post("/", %{
      "session" => %{"email" => jo.email, "password" => "password"}
    })
    response = SessionsController.handle_request(request, :nostate)
    assert 302 == response.status
    assert "/customers/#{jo.id}" == Raxx.Patch.response_location(response)
  end
end
