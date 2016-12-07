defmodule UM.Web.AdminTest do
  use ExUnit.Case

  import Raxx.Test

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

  # This would be the header field but after the gateway we are not sending cookies
  # headers: [{"cookie", "raxx.session=admin"}]}
  test "index page is available to admin", %{admin: admin} do
    request = get("/", session(%{customer: %{id: admin.id}}))
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end

  test "index page is forbidden to customer", %{customer: customer} do
    request = get("/", session(%{customer: %{id: customer.id}}))
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 403
  end

  test "pieces page is available to admin", %{admin: admin} do
    request = get("/pieces", session(%{customer: %{id: admin.id}}))
    response = UM.Web.Admin.handle_request(request, %{})
    # Check that the correct page is served
    assert response.status == 200
  end

  test "customers page is available to admin", %{admin: admin} do
    request = get("/customers", session(%{customer: %{id: admin.id}}))
    response = UM.Web.Admin.handle_request(request, %{})
    # Check that the correct page is served
    assert response.status == 200
  end

  def session(data) do
    [{"um-session", struct(Session, data)}]
  end
end
