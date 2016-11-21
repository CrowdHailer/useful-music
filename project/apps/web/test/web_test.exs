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

  test "can create new customer" do
    request = %Raxx.Request{
      path: ["customers", "create"],
      method: :POST,
      body: Plug.Conn.Query.encode(%{
        customer: %{
          first_name: "Bill",
          last_name: "Kennedy",
          email: "bill@usa.com",
          password: "password",
          password_confirmation: "password",
          country: "TODO",
          terms_agreement: "on"
        }
      }),
      headers: [{"content-type", "application/x-www-form-urlencoded"}]
    }
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 201
  end
end
