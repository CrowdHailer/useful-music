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

  test "login will add user id to session" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = post("/sessions", %{
      headers: [{"content-type", "application/x-www-form-urlencoded"}],
      body: "session[email]=#{bugs.email}&session[password]=#{bugs.password}"
    })
    response = UM.Web.handle_request(request, :no_state)
    assert delivered_cookies = :proplists.get_value("set-cookie", response.headers)
    assert "raxx.session=" <> _ = delivered_cookies
    # TODO assert correct session contents
  end

  test "login page redirects if already logged in" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/sessions/new", UM.Web.Session.external_session(%{customer_id: bugs.id}))
    response = UM.Web.handle_request(request, :no_state)
    assert 302 == response.status
    assert "/customers/#{bugs.id}" == Raxx.Patch.response_location(response)
  end

  test "login with invalid credentials shows flash" do
    request = post("/sessions", %{
      headers: [{"content-type", "application/x-www-form-urlencoded"}],
      body: "session[email]=interloper@example.com&session[password]=bad_password"
    })

    response = UM.Web.handle_request(request, :no_state)
    location = Raxx.Patch.response_location(response)
    request = get(location)
    response = UM.Web.handle_request(request, :no_state)
    assert String.contains?(response.body, "Invalid login details")
  end

  test "logout will delete session" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = post("/sessions", %{
      body: "_method=DELETE",
      headers: [{"content-type", "application/x-www-form-urlencoded"}]
    }, UM.Web.Session.external_session(%{customer_id: bugs.id}))
    response = UM.Web.handle_request(request, :no_state)
    assert 303 == response.status
    # TODO check cookies
  end

  test "can view the admin page" do
    bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/admin/customers", UM.Web.Session.external_session(%{customer_id: bugs.id}))
    response = UM.Web.handle_request(request, :no_state)
    assert 200 == response.status
  end
end
