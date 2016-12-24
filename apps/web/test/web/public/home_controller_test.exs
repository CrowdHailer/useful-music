defmodule UM.Web.HomeControllerTest do
  use ExUnit.Case
  import Raxx.Test

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  test "home page returns pieces" do
    _piece = UM.Web.Fixtures.canonical_piece
    request = get("/")
    response = UM.Web.HomeController.handle_request(request, %{})
    assert response.status == 200
    assert String.contains?(response.body, "UD101")
  end

  test "redirects to the correct search for piano page" do
    request = get("/piano")
    response = UM.Web.HomeController.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[piano]=on" == Raxx.Patch.response_location(response)
  end

  test "redirects to the correct search for flute page" do
    request = get("/flute")
    response = UM.Web.HomeController.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[flute]=on" == Raxx.Patch.response_location(response)
  end

  test "redirects to the correct search for woodwind page" do
    request = get("/woodwind")
    response = UM.Web.HomeController.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?" <> _query = Raxx.Patch.response_location(response)
  end

  # TODO test less as setting a currency preference is tested in the session tests
  test "sets currency preference for a customer" do
    jo = UM.Web.Fixtures.jo_brand
    session = UM.Web.Session.new |> UM.Web.Session.login(jo)
    request = post("/currency", form_data(%{"preference" => "USD"}), [{"um-session", session}])
    response = UM.Web.HomeController.handle_request(request, %{})
    assert "USD" == UM.Accounts.fetch_customer(jo.id).currency_preference
    assert response.status == 302
    assert "/" == Raxx.Patch.response_location(response)
    assert "USD" = Raxx.Patch.response_session(response) |> UM.Web.Session.currency_preference
    # assert jo.id == id
  end

  test "sets currency preference for a guest" do
    request = post("/currency", form_data(%{"preference" => "USD"}), [{"um-session", UM.Web.Session.new}])
    response = UM.Web.HomeController.handle_request(request, %{})
    assert response.status == 302
    assert "/" == Raxx.Patch.response_location(response)
    assert "USD" = Raxx.Patch.response_session(response) |> UM.Web.Session.currency_preference
  end

  test "setting currency redirects to referrer" do
    request = post("/currency", form_data(%{"preference" => "USD"}), [
      {"um-session", UM.Web.Session.new},
      {"referer", "/pieces"}
    ])
    response = UM.Web.HomeController.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces" == Raxx.Patch.response_location(response)
  end
end
