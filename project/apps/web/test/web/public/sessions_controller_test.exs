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
    request = get({"/new", %{"target" => "/admin"}})
    response = SessionsController.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "name=\"requested_path\" value=\"/admin\"")
  end

  test "logging in", %{customer: customer} do
    request = post("/", form_data(%{
      session: %{email: customer.email, password: customer.password}
    }))
    response = SessionsController.handle_request(request, :nostate)
    assert 303 == response.status
    assert "/customers/#{customer.id}" == Raxx.Patch.response_location(response)
    # DEBT test encoded session.
  end
end
