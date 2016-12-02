defmodule UM.Web.HomeTest do
  use ExUnit.Case, async: true

  import Raxx.Test

  test "home page returns pieces" do
    request = get("/", [{"um-user-id", "dummy-customer-id"}])
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 200
    # TODO test page contents
  end

  test "redirects to the correct search for piano page" do
    request = get("/piano", [{"um-user-id", "dummy-customer-id"}])
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[piano]=on" == Raxx.Patch.response_location(response)
  end

  test "redirects to the correct search for flute page" do
    request = get("/flute", [{"um-user-id", "dummy-customer-id"}])
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[flute]=on" == Raxx.Patch.response_location(response)
  end

  # TODO write test without page_size redirection
  # test "redirects to the correct search for woodwind page" do
  #   request = %Raxx.Request{
  #     path: ["piano"],
  #     headers: [{"um-user-id", "dummy-customer-id"}]
  #   }
  #   response = UM.Web.Home.handle_request(request, %{})
  #   assert response.status == 302
  # end

  # FIXME check guest vs logged in
  test "sets currency preference" do
    request = post("/currency", form_data(%{preference: "USD"}), [{"um-user-id", "dummy-guest-id"}])
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/" == Raxx.Patch.response_location(response)
    assert {"um-set-session", %{currency_preference: "USD"}} == List.keyfind(response.headers, "um-set-session", 0)
  end

  def session(data) do
    [{"um-session", struct(Session, data)}]
  end
end
