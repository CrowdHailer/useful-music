defmodule UM.Web.AdminTest do
  use ExUnit.Case

  import Raxx.Test

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  test "index page is available to admin" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/", UM.Web.Session.customer_session(bugs))
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end

  test "index page is forbidden to customer" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/", UM.Web.Session.customer_session(jo))
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 403
  end

  test "pieces page is available to admin" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/pieces", UM.Web.Session.customer_session(bugs))
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end

  test "customers page is available to admin" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/customers", UM.Web.Session.customer_session(bugs))
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end
end