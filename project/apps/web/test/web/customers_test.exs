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

  test "can create new customer" do
    # This is crud
    Moebius.Db.start_link(Moebius.get_connection)
    Moebius.Query.db(:customers) |> Moebius.Query.delete |> Moebius.Db.run
    assert [] == UM.Customers.all

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
    assert "/customers/" <> id = Raxx.Patch.response_location(response)
    assert response.status == 303
    assert %{first_name: "Bill"} = UM.Customers.fetch(id)
  end

  test "rerenders form for bad password" do
    # This is crud
    Moebius.Db.start_link(Moebius.get_connection)
    Moebius.Query.db(:customers) |> Moebius.Query.delete |> Moebius.Db.run
    assert [] == UM.Customers.all

    request = post("/", form_data(%{
      customer: %{
        first_name: "Bill",
        last_name: "Kennedy",
        email: "bill@usa.com",
        password: "easy",
        password_confirmation: "password",
        country: "TODO",
        terms_agreement: "on"
      }
      }))
      response = Controller.handle_request(request, :no_state)
      assert response.status == 400
      assert String.contains?(response.body, "too short")
  end
end
