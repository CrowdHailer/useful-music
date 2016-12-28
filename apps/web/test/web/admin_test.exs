defmodule UM.Web.AdminTest do
  use ExUnit.Case

  import Raxx.Request

  setup do
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  test "index page is available to admin" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    request = get("/", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(bugs)}])
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end

  test "index page is forbidden to customer" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = get("/", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 403
  end

  test "pieces page is available to admin" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    request = get("/pieces", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(bugs)}])
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end

  test "customers page is available to admin" do
    bugs = UM.Accounts.Fixtures.bugs_bunny
    request = get("/customers", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(bugs)}])
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end
end
