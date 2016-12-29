defmodule UM.Web.Admin.CustomersControllerTest do
  use ExUnit.Case
  alias UM.Web.Admin.CustomersController, as: Controller

  import Raxx.Request

  setup do
    :ok = UM.Accounts.Fixtures.clear_db
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  test "index page shows customers" do
    _jo = UM.Accounts.Fixtures.jo_brand
    _bugs = UM.Accounts.Fixtures.bugs_bunny
    request = get("/")
    response = Controller.handle_request(request, :nostate)
    assert String.contains?(response.body, "Jo Brand")
    assert String.contains?(response.body, "Bugs Bunny")
  end

  test "can make customer an admin" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = post("/#{jo.id}/admin", Raxx.Test.form_data(%{}))
    response = Controller.handle_request(request, :nostate)
    {:ok, updated_jo} = UM.Accounts.CustomersRepo.fetch_by_id(jo.id)
    assert true == updated_jo.admin
    request = Raxx.Patch.follow(response)
    assert ["admin", "customers"] == request.path
    assert %{success: "Jo Brand is now an admin"} = Raxx.Patch.get_header(response, "um-flash")
  end

  test "can make remove admin access" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    request = delete("/#{bugs.id}/admin", Raxx.Test.form_data(_method: "DELETE"))
    response = Controller.handle_request(request, :nostate)
    {:ok, updated_customer} = UM.Accounts.CustomersRepo.fetch_by_id(bugs.id)
    assert false == updated_customer.admin
    request = Raxx.Patch.follow(response)
    assert ["admin", "customers"] == request.path
    assert %{success: "Bugs Bunny is now not an admin"} = Raxx.Patch.get_header(response, "um-flash")
  end
end
