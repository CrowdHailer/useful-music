defmodule UM.Web.SessionsControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Web.SessionsController

  test "login page (/sessions/new) maintains the users target" do
    request = get({"/new", %{"target" => "/admin"}})
    response = SessionsController.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "name=\"requested_path\" value=\"/admin\"")
  end

  test "logging in" do
    request = post("/", form_data(%{
      session: %{email: "bob@email.com", password: "password"},
      target: "/admin"
    }))
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/admin" == Raxx.Patch.response_location(response)
  end
end
