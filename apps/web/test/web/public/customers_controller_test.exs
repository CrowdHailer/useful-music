defmodule UM.Web.CustomersControllerControllerTest do
  use ExUnit.Case

  import Raxx.Test

  alias UM.Web.CustomersControllerController, as: Controller

  setup do
    :ok = UM.Web.Fixtures.clear_db
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
    assert List.keyfind(response.headers, "um-flash", 0)
    customer = UM.Accounts.fetch_customer(id)
    assert "Bill" == customer.first_name
    assert "USD" == customer.currency_preference
    # TODO check the last email sent
    assert {"um-set-session", %{customer_id: ^id}} = List.keyfind(response.headers, "um-set-session", 0)
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
      }), UM.Web.Session.guest_session)
      response = Controller.handle_request(request, :no_state)
      assert response.status == 400
      assert String.contains?(response.body, "too short")
  end

  test "customer page shows orders" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/#{jo.id}", UM.Web.Session.customer_session(jo))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "admin can view a customer page" do
    jo = UM.Web.Fixtures.jo_brand
    bugs = UM.Web.Fixtures.bugs_bunny
    request = get("/#{jo.id}", UM.Web.Session.customer_session(bugs))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "customer can not view anothers customer page" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/#{jo.id}", UM.Web.Session.guest_session)
    response = Controller.handle_request(request, :no_state)
    assert response.status == 404
  end

  test "can visit a customers edit page" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/#{jo.id}/edit", UM.Web.Session.customer_session(jo))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "can update a customers details" do
    jo = UM.Web.Fixtures.jo_brand
    request = put("/#{jo.id}", form_data(%{
      "customer" => %{
        "first_name" => "Joanna",
        "last_name" => "Brand",
        "email" => "Jo@hotmail.com",
        "country" => "GB",
        "question_1" => "I play bongos",
        "question_2" => "",
        "question_3" => ""
      }}), UM.Web.Session.customer_session(jo))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
    redirection = get(Raxx.Patch.response_location(response))
    assert ["customers", id] = redirection.path
    assert id == jo.id
    jo = UM.Accounts.fetch_customer(id)
    assert "I play bongos" == jo.question_1
    assert "Joanna" == jo.first_name
  end

  test "cant update a customers details with invalid name" do
    jo = UM.Web.Fixtures.jo_brand
    request = put("/#{jo.id}", form_data(%{
      "customer" => %{
        "first_name" => "",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "country" => "TODO",
        "question_1" => "I play bongos",
        "question_2" => "",
        "question_3" => "",
      }}), UM.Web.Session.customer_session(jo))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 400
    assert String.contains?(response.body, "required")
  end

  test "can visit a customers change password page" do
    jo = UM.Web.Fixtures.jo_brand
    request = get("/#{jo.id}/change_password", UM.Web.Session.customer_session(jo))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "can update password" do
    jo = UM.Web.Fixtures.jo_brand
    request = put("/#{jo.id}/change_password", form_data(%{
      "customer" => %{
        "current_password" => "password",
        "password" => "updatedSecret",
        "password_confirmation" => "updatedSecret"
      }}), UM.Web.Session.customer_session(jo))
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
    redirection = get(Raxx.Patch.response_location(response))
    assert ["customers", id] = redirection.path
    assert id == jo.id
    jo = UM.Accounts.fetch_customer(id)
    assert "updatedSecret" == jo.password
  end

  # DEBT keep success path after login/signup
end
