defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  import Raxx.Test

  setup do
    Moebius.Query.db(:customers) |> Moebius.Query.delete |> UM.Accounts.Db.run
    assert [] == UM.Accounts.all_customers
    customer = UM.Accounts.signup_customer(%{
      first_name: "Dan",
      last_name: "Dare",
      email: "dan@example.com",
      password: "password",
      country: "GB"
    })
    admin = %{id: _id} = UM.Accounts.signup_customer(%{
      first_name: "Bugs",
      last_name: "Bunny",
      email: "bugs@hotmail.com",
      password: "password",
      country: "GB",
      admin: true
    })
    {:ok, %{customer: customer, admin: admin}}
  end

  test "The sites stylesheets are served" do
    request = get("/stylesheets/admin.css")
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "about controller is mounted" do
    request = get("/about")
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "login will add user id to session" do
    request = post("/sessions", form_data(%{
      session: %{email: "dan@example.com", password: "password"}
    }))
    response = UM.Web.handle_request(request, :no_state)
    assert delivered_cookies = :proplists.get_value("set-cookie", response.headers)
    assert "raxx.session=" <> _ = delivered_cookies
    # TODO assert correct session contents
  end

  test "login page redirects if already logged in", %{customer: customer} do
    request = get("/sessions/new", external_session(%{customer: %{id: customer.id}}))
    response = UM.Web.handle_request(request, :no_state)
    assert 303 == response.status
    assert "/customers/#{customer.id}" == Raxx.Patch.response_location(response)
  end

  test "login with invalid credentials shows flash" do
    request = post("/sessions", form_data(%{
      session: %{email: "interloper@example.com", password: "bad_password"}
    }))
    response = UM.Web.handle_request(request, :no_state)
    location = Raxx.Patch.response_location(response)
    request = get(location)
    response = UM.Web.handle_request(request, :no_state)
    assert String.contains?(response.body, "Invalid login details")
  end

  test "logout will delete session", %{customer: customer} do
    request = post("/sessions", form_data(%{
      _method: "DELETE"
    }), external_session(%{customer: %{id: customer.id}}))
    response = UM.Web.handle_request(request, :no_state)
    assert 303 == response.status
    # TODO check cookies
  end

  test "can view the admin page", %{admin: admin} do
    request = get("/admin/customers", external_session(%{customer: %{id: admin.id}}))
    response = UM.Web.handle_request(request, :no_state)
    assert 200 == response.status
  end

  def external_session(data) do
    [{"cookie", "raxx.session="<>(struct(Session, data) |> Poison.encode!)}]
  end
end
