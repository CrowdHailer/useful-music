defmodule UM.Web.CustomersTest do
  use ExUnit.Case, async: true

  import Raxx.Test

  alias UM.Web.Customers, as: Controller

  test "new page is available" do
    request = get("/new")
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
  end

  test "can create new customer" do
    request = post("/", form_data(%{
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
    response = Controller.handle_request(request, :no_state)
    assert response.status == 303
  end
end
