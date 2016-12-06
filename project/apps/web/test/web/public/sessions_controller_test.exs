defmodule UM.Web.SessionsControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Web.SessionsController

  setup do
    Moebius.Query.db(:customers) |> Moebius.Query.delete |> UM.Accounts.Db.run
    assert [] == UM.Accounts.all_customers
    customer = %{id: _id} = UM.Accounts.signup_customer(%{
      first_name: "Dan",
      last_name: "Dare",
      email: "dan@example.com",
      password: "password",
      country: "GB"
    })
    {:ok, %{customer: customer}}
  end

  test "login page (/sessions/new) maintains the users target" do
    request = get({"/new", %{"target" => "/admin"}}, session(%{}))
    response = SessionsController.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "name=\"requested_path\" value=\"/admin\"")
  end

  test "redirects to account page if already logged it", %{customer: customer} do
    request = get("/new", session(%{customer: %{id: customer.id}}))
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/customers/#{customer.id}" == Raxx.Patch.response_location(response)
  end

  test "logging in sends user to their orders page", %{customer: customer} do
    request = post("/", %{
      "session" => %{"email" => customer.email, "password" => customer.password}
    })
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/customers/#{customer.id}" == Raxx.Patch.response_location(response)
    # DEBT test encoded session.
  end

  test "loggin in will redirect to the target if given", %{customer: customer} do
    request = post("/", %{
      "session" => %{"email" => customer.email, "password" => customer.password},
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

  test "log out will destroy session", %{customer: customer} do
    request = delete("/", session(%{customer: %{id: customer.id}}))
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

  def session(data) do
    [{"um-session", struct(Session, data)}]
  end
end
