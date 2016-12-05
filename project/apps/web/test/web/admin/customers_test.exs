defmodule UM.Web.Admin.CustomersTest do
  use ExUnit.Case
  alias UM.Web.Admin.Customers

  import Raxx.Test

  setup do
    Moebius.Query.db(:customers) |> Moebius.Query.delete |> UM.Accounts.Db.run
    assert [] == UM.Accounts.all_customers
    %{id: id} = UM.Accounts.signup_customer(%{
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
    # SEE end for paginated customer page
    {:ok, %{customer: %{id: id}, admin: admin}}
  end

  test "index page shows customers" do
    request = get("/")
    response = Customers.handle_request(request, :nostate)
    assert String.contains?(response.body, "Dan Dare")
    assert String.contains?(response.body, "Bugs Bunny")
  end

  test "can make customer an admin", %{customer: customer} do
    request = post("/#{customer.id}/admin", form_data(%{}))
    response = Customers.handle_request(request, :nostate)
    updated_customer = UM.Accounts.fetch_customer(customer.id)
    assert true == updated_customer.admin
    assert url = "/admin/customers?" <> _query = Raxx.Patch.response_location(response)
    request = get(url)
    {flash, _request} = UM.Web.Flash.from_request(request)
    assert %{success: "Dan Dare is now an admin"} = flash
  end

  test "can make remove admin access", %{admin: admin} do
    request = delete("/#{admin.id}/admin", form_data(_method: "DELETE"))
    response = Customers.handle_request(request, :nostate)
    updated_user = UM.Accounts.fetch_customer(admin.id)
    assert false == updated_user.admin
    assert url = "/admin/customers?" <> _query = Raxx.Patch.response_location(response)
    request = get(url)
    {flash, _request} = UM.Web.Flash.from_request(request)
    assert %{success: "Bugs Bunny is now not an admin"} = flash
  end

  # editing the admin status of a missing customer should never arrise
end
