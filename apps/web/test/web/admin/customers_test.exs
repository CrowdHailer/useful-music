defmodule UM.Web.Admin.CustomersTest do
  use ExUnit.Case
  alias UM.Web.Admin.Customers

  import Raxx.Test

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  test "index page shows customers" do
    _jo = UM.Web.Fixtures.jo_brand
    _bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/")
    response = Customers.handle_request(request, :nostate)
    assert String.contains?(response.body, "Jo Brand")
    assert String.contains?(response.body, "Bugs Bunny")
  end

  test "can make customer an admin" do
    jo = UM.Web.Fixtures.jo_brand
    request = post("/#{jo.id}/admin", form_data(%{}))
    response = Customers.handle_request(request, :nostate)
    assert true == UM.Accounts.fetch_customer(jo.id).admin
    request = Raxx.Patch.follow(response)
    assert ["admin", "customers"] == request.path
    {flash, _request} = UM.Web.Flash.from_request(request)
    assert %{success: "Jo Brand is now an admin"} = flash
  end

  test "can make remove admin access" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = delete("/#{bugs.id}/admin", form_data(_method: "DELETE"))
    response = Customers.handle_request(request, :nostate)
    assert false == UM.Accounts.fetch_customer(bugs.id).admin
    request = Raxx.Patch.follow(response)
    assert ["admin", "customers"] == request.path
    {flash, _request} = UM.Web.Flash.from_request(request)
    assert %{success: "Bugs Bunny is now not an admin"} = flash
  end
end
