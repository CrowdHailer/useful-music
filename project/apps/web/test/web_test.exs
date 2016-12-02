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
    {:ok, %{customer: customer}}
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
  # TODO delete session 

  def external_session(data) do
    [{"cookie", "raxx.session="<>(struct(Session, data) |> Poison.encode!)}]
  end
end
