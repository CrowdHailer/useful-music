defmodule UM.Web.Admin.CustomersTest do
  use ExUnit.Case, async: true
  alias UM.Web.Admin.Customers

  import Raxx.Test

  test "index page shows customer" do
    request = get("/")
    response = Customers.handle_request(request, :nostate)
    assert String.contains?(response.body, "Issac")
  end

  test "can make customer an admin" do
    request = post("/dummy-customer-id/admin", form_data(%{}))
    response = Customers.handle_request(request, :nostate)
    # TODO test repository edited
    # TODO test flash added to location
    assert "/admin/customers" == Raxx.Patch.response_location(response)
  end

  # Same test for delete and missing

  test "can make remove admin access" do
    request = post("/dummy-customer-id/admin", form_data(_method: "DELETE"))
    response = Customers.handle_request(request, :nostate)
    # TODO test repository
    # TODO test flash
    assert "/admin/customers" == Raxx.Patch.response_location(response)
  end
end
