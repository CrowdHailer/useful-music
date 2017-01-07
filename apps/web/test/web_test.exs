defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  import Raxx.Request

  setup do
    :ok = UM.Accounts.Fixtures.clear_db
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
    session_secret_key = Application.get_env(:web, :session_secret_key)
    packed_session = Poison.encode!(%{account_id: bugs.id})
    digest = :crypto.hmac(:sha, session_secret_key, packed_session) |> Base.encode64
    signed_session = "#{digest}--#{packed_session}"
    request = get("/admin/customers", [{"cookie", "raxx.session=" <> signed_session}])
    response = UM.Web.handle_request(request, :no_state)
    assert 200 == response.status
  end
end
