defmodule UM.Web.CustomersTest do
  #not async untill removed reverence to db
  use ExUnit.Case

  import Raxx.Test

  alias UM.Web.Customers, as: Controller

  test "new page is available" do
    request = get("/new")
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
  end

  @tag :skip
  test "can create new customer" do
    # This is crud
    customers = UM.Customers.all
    Moebius.Query.db(:customers) |> Moebius.Query.delete |> Moebius.Db.run

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
    location = Raxx.Patch.response_location(response)
    |> IO.inspect
    assert response.status == 303
    customers = UM.Customers.all
    |> IO.inspect

  end
end
