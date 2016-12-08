defmodule UM.Web.CustomersTest do
  #not async untill removed reverence to db
  use ExUnit.Case

  import Raxx.Test

  alias UM.Web.Customers, as: Controller

  setup do
    Moebius.Query.db(:customers) |> Moebius.Query.delete |> UM.Accounts.Db.run
    assert [] == UM.Accounts.all_customers
    %{id: id} = UM.Accounts.signup_customer(%{
      first_name: "Dan",
      last_name: "Dare",
      email: "dan@example.com",
      password: "password",
      country: "GB"
    })
    admin = %{id: _id} = UM.Accounts.signup_customer(%{
      first_name: "Bugs",
      last_name: "Bunny",
      email: "bugs@hotmail.com",
      password: "password",
      country: "GB",
      admin: true
    })
    {:ok, %{customer: %{id: id}, admin: admin}}
  end

  test "new page is available" do
    request = get("/new")
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
  end

  test "can create new customer" do
    request = post("/", form_data(%{
      "customer" => %{
        "first_name" => "Bill",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "password" => "password",
        "password_confirmation" => "password",
        "country" => "TODO",
        "terms_agreement" => "on"
      }
    }))
    response = Controller.handle_request(request, :no_state)
    assert "/customers/" <> id = Raxx.Patch.response_location(response)
    assert response.status == 303
    assert %{first_name: "Bill"} = UM.Accounts.fetch_customer(id)
    # TODO test the flash message
    # TODO check the last email sent
  end

  test "rerenders form for bad password" do
    request = post("/", form_data(%{
      "customer" => %{
        "first_name" => "Bill",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "password" => "easy",
        "password_confirmation" => "password",
        "country" => "TODO",
        "terms_agreement" => "on"
      }
      }))
      response = Controller.handle_request(request, :no_state)
      assert response.status == 400
      assert String.contains?(response.body, "too short")
  end

  test "customer page shows orders", %{customer: customer} do
    request = get("/#{customer.id}", UM.Web.Session.customer_session(customer))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "admin can view a customer page", %{admin: admin, customer: customer} do
    request = get("/#{customer.id}", UM.Web.Session.customer_session(admin))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  @tag :skip
  # Wait untill set up proper fixtures
  test "customer can not view anothers customer page", %{customer: %{id: id}} do
    request = get("/#{id}", UM.Web.Session.guest_session)
    response = Controller.handle_request(request, :no_state)
    assert response.status == 404
  end

  # DEBT keep success path after login/signup
end
