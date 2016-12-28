defmodule UM.Web.CustomersControllerControllerTest do
  use ExUnit.Case
  use Bamboo.Test
  import Raxx.Request

  alias UM.Web.CustomersControllerController, as: Controller

  setup do
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  test "new page is available" do
    request = get("/new")
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
  end

  test "can create new customer" do
    request = post("/", Raxx.Test.form_data(%{
      "customer" => %{
        "first_name" => "Bill",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "password" => "password",
        "password_confirmation" => "password",
        "country" => "GB",
        "terms_agreement" => "on"
      }
    }), [{"um-session", UM.Web.Session.new |> UM.Web.Session.select_currency("USD")}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
    assert location = Raxx.Patch.response_location(response)
    redirection = get(location)
    assert ["customers", id] = redirection.path
    assert List.keyfind(response.headers, "um-flash", 0)
    {:ok, customer} = UM.Accounts.fetch_by_id(id)
    assert "Bill" == customer.first_name
    assert "USD" == customer.currency_preference
    assert id == Raxx.Patch.response_session(response).account.id
    assert_delivered_email UM.Web.Emails.account_created(customer)
  end

  test "rerenders form for bad password" do
    request = post("/", Raxx.Test.form_data(%{
      "customer" => %{
        "first_name" => "Bill",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "password" => "easy",
        "password_confirmation" => "password",
        "country" => "GB",
        "terms_agreement" => "on"
      }
      }), [{"um-session", UM.Web.Session.new}])
      response = Controller.handle_request(request, :no_state)
      assert response.status == 400
      assert String.contains?(response.body, "too short")
  end

  test "customer page shows orders" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = get("/#{jo.id}", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "admin can view a customer page" do
    jo = UM.Accounts.Fixtures.jo_brand
    bugs = UM.Accounts.Fixtures.bugs_bunny
    request = get("/#{jo.id}", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(bugs)}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "customer can not view anothers customer page" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = get("/#{jo.id}", [{"um-session", UM.Web.Session.new}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 404
  end

  test "can visit a customers edit page" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = get("/#{jo.id}/edit", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "can update a customers details" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = put("/#{jo.id}", Raxx.Test.form_data(%{
      "customer" => %{
        "first_name" => "Joanna",
        "last_name" => "Brand",
        "email" => "Jo@hotmail.com",
        "country" => "GB",
        "question_1" => "I play bongos",
        "question_2" => "",
        "question_3" => ""
      }}), [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
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
    jo = UM.Accounts.Fixtures.jo_brand
    request = put("/#{jo.id}", Raxx.Test.form_data(%{
      "customer" => %{
        "first_name" => "",
        "last_name" => "Kennedy",
        "email" => "bill@usa.com",
        "country" => "GB",
        "question_1" => "I play bongos",
        "question_2" => "",
        "question_3" => "",
      }}), [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 400
    assert String.contains?(response.body, "required")
  end

  test "can visit a customers change password page" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = get("/#{jo.id}/change_password", [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "can update password" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = put("/#{jo.id}/change_password", Raxx.Test.form_data(%{
      "customer" => %{
        "current_password" => "password",
        "password" => "updatedSecret",
        "password_confirmation" => "updatedSecret"
      }}), [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
    redirection = get(Raxx.Patch.response_location(response))
    assert ["customers", id] = redirection.path
    assert id == jo.id
    jo = UM.Accounts.fetch_customer(id)
    assert "updatedSecret" == jo.password
  end

  test "failed to update password" do
    jo = UM.Accounts.Fixtures.jo_brand
    request = put("/#{jo.id}/change_password", Raxx.Test.form_data(%{
      "customer" => %{
        "current_password" => "password",
        "password" => "bad",
        "password_confirmation" => "bad"
      }}), [{"um-session", UM.Web.Session.new |> UM.Web.Session.login(jo)}])
    response = Controller.handle_request(request, :no_state)
    assert response.status == 302
  end

  # DEBT keep success path after login/signup
end
