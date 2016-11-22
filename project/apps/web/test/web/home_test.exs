defmodule UM.Web.HomeTest do
  use ExUnit.Case, async: true

  test "home page returns pieces" do
    request = %Raxx.Request{
      path: [],
      headers: [{"um-user-id", "dummy-customer-id"}]
    }
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 200
    # TODO test page contents
  end

  test "redirects to the correct search for piano page" do
    request = %Raxx.Request{
      path: ["piano"],
      headers: [{"um-user-id", "dummy-customer-id"}]
    }
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[piano]=on" == Raxx.Patch.response_location(response)
  end

  test "redirects to the correct search for flute page" do
    request = %Raxx.Request{
      path: ["flute"],
      headers: [{"um-user-id", "dummy-customer-id"}]
    }
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
    request = %Raxx.Request{
      method: :POST,
      path: ["currency"],
      headers: [
        {"um-user-id", "dummy-guest-id"},
        {"content-type", "application/x-www-form-urlencoded"}],
      body: Plug.Conn.Query.encode(%{
        preference: "USD",
      })
    }
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/" == Raxx.Patch.response_location(response)
    assert {"set-cookie", "um.currency_preference=USD"} == List.keyfind(response.headers, "set-cookie", 0)
  end


end
