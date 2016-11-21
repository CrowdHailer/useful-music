defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  test "The sites css assets are served" do
    request = %Raxx.Request{
      path: ["assets", "site.css"]
    }
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 200
  end
end
