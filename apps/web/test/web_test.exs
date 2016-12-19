defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  import Raxx.Test

  setup do
    :ok = UM.Web.Fixtures.clear_db
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
    bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/admin/customers", UM.Web.Session.external_session(%{customer_id: bugs.id}))
    response = UM.Web.handle_request(request, :no_state)
    assert 200 == response.status
  end
end
