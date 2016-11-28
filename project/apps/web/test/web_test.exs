defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  import Raxx.Test

  test "The sites stylesheets are served" do
    request = get("/stylesheets/admin.css")
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "can create new customer" do
    request = post("/customers/create", form_data(%{
      customer: %{
        first_name: "Bill",
        last_name: "Kennedy",
        email: "bill@usa.com",
        password: "password",
        password_confirmation: "password",
        country: "TODO",
        terms_agreement: "on"
      }
    }))
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 201
  end

  test "login will add user id to session" do
    request = post("/login", form_data(%{email: "bill@usa.com"}))
    response = UM.Web.handle_request(request, :no_state)
    # TODO assert
  end
end
