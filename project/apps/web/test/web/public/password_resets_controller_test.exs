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
    |> Controller.handle_request
    assert String.contains?(response.body, "Email not found")
  end
end
