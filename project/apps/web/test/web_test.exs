defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "the static assets from rack" do
    request = %Raxx.Request{
      path: ["assets", "app.css"]
    }
    response = UM.Web.handle_request(request, :no_state)
    IO.inspect(response)
    request = %Raxx.Request{
      path: ["assets", "components", "other.css"]
    }
    response = UM.Web.handle_request(request, :no_state)
    IO.inspect(response)
  end
end
