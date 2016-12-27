defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  import Raxx.Request

  setup do
    :ok = UM.Catalogue.Fixtures.clear_db
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

  test "can view the admin page" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    request = get("/admin/customers", [{"cookie", "raxx.session=" <> Poison.encode!(%{account_id: bugs.id})}])
    response = UM.Web.handle_request(request, :no_state)
    assert 200 == response.status
  end
end
