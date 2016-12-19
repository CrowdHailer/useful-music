defmodule UM.Web.PasswordResetsControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Web.PasswordResetsController, as: Controller

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  test "new page is available" do
    request = get("/new")
    response = Controller.handle_request(request, :nostate)
    assert 200 = response.status
  end

  test "create password reset" do
    jo = UM.Web.Fixtures.jo_brand
    request = post("/", form_data(%{"customer" => %{"email" => jo.email}}))
    |> Controller.handle_request(:nostate)
    |> Raxx.Patch.follow
    {flash, request} = UM.Web.Flash.from_request(request)
    assert %{success: "A password reset has been sent to your email"} = flash
    assert ["sessions", "new"] == request.path
  end

  test "rerenders when email not found" do
    response = post("/", form_data(%{"customer" => %{"email" => "a@b.com"}}))
    |> Controller.handle_request(:nostate)
    assert String.contains?(response.body, "Email not found")
  end

  test "edit page is available for token" do
    jo = UM.Web.Fixtures.jo_brand
    {:ok, customer} = UM.Accounts.create_password_reset(jo.email)
    request = get({"/#{customer.password_reset_token}/edit", email: jo.email})
    response = Controller.handle_request(request, :nostate)
    assert 200 = response.status
  end

  test "can reset password" do
    jo = UM.Web.Fixtures.jo_brand
    {:ok, customer} = UM.Accounts.create_password_reset(jo.email)
    request = put("/#{customer.password_reset_token}", form_data(%{
      "customer" => %{
        "email" => jo.email,
        "password" => "mySecret",
        "password_confirmation" => "mySecret"}}))
    |> Controller.handle_request(:nostate)
    |> Raxx.Patch.follow
    assert ["sessions", "new"] == request.path
  end

end
