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
    }), UM.Web.Session.guest_session(currency_preference: "USD"))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
    assert location = Raxx.Patch.response_location(response)
    redirection = get(location)
    assert ["customers", id] = redirection.path
    assert _flash = redirection.query["flash"]
    customer = UM.Accounts.fetch_customer(id)
    assert "Bill" == customer.first_name
    assert "USD" == customer.currency_preference
    # TODO check the last email sent
    # TODO check session is set
  end

  test "rerenders form for bad password", %{customer: customer} do
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
      }), UM.Web.Session.customer_session(customer))
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

  test "customer can not view anothers customer page", %{customer: %{id: id}} do
    request = get("/#{id}", UM.Web.Session.guest_session)
    response = Controller.handle_request(request, :no_state)
    assert response.status == 404
  end

  test "can visit a customers edit page", %{customer: customer} do
    request = get("/#{customer.id}/edit", UM.Web.Session.customer_session(customer))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "can update a customers details", %{customer: customer} do
    request = put("/#{customer.id}", form_data(%{
      "customer" => %{
        "first_name" => "Enrique",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "country" => "TODO",
        "question_1" => "I play bongos",
        "question_2" => "",
        "question_3" => ""
      }}), UM.Web.Session.customer_session(customer))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
    redirection = get(Raxx.Patch.response_location(response))
    assert ["customers", id] = redirection.path
    assert id == customer.id
    customer = UM.Accounts.fetch_customer(id)
    assert "I play bongos" == customer.question_1
    assert "Enrique" == customer.first_name
  end

  test "cant update a customers details with invalid name", %{customer: customer} do
    request = put("/#{customer.id}", form_data(%{
      "customer" => %{
        "first_name" => "",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "country" => "TODO",
        "question_1" => "I play bongos",
        "question_2" => "",
        "question_3" => "",
      }}), UM.Web.Session.customer_session(customer))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 400
    assert String.contains?(response.body, "required")
  end

  test "can visit a customers change password page", %{customer: customer} do
    request = get("/#{customer.id}/change_password", UM.Web.Session.customer_session(customer))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "can update password", %{customer: customer} do
    request = put("/#{customer.id}/change_password", form_data(%{
      "customer" => %{
        "current_password" => "password",
        "password" => "updatedSecret",
        "password_confirmation" => "updatedSecret"
      }}), UM.Web.Session.customer_session(customer))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
    redirection = get(Raxx.Patch.response_location(response))
    assert ["customers", id] = redirection.path
    assert id == customer.id
    customer = UM.Accounts.fetch_customer(id)
    assert "updatedSecret" == customer.password
  end

  # DEBT keep success path after login/signup
end
