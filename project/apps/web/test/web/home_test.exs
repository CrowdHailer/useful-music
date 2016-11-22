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
    assert "/pieces?catalogue_search[piano]=on"
  end

  test "redirects to the correct search for flute page" do
    request = %Raxx.Request{
      path: ["flute"],
      headers: [{"um-user-id", "dummy-customer-id"}]
    }
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[flute]=on"
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

end
