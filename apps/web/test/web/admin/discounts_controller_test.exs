defmodule Um.Web.Admin.DiscountsControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Web.Admin.DiscountsController, as: Controller

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  test "index page shows all discounts" do
    discount = %{code: code} = UM.Web.Fixtures.test_discount
    request = get("/")
    response = Controller.handle_request(request, [])
    assert 200 == response.status
    assert String.contains?(response.body, code)
  end

  test "new page is ready" do
    request = get("/new")
    response = Controller.handle_request(request, [])
    assert 200 == response.status
  end

  test "can create a discount" do
    request = post("/", form_data(%{"discount" => %{
      "code" => "mycode23",
      "allocation" => "100",
      "customer_allocation" => "1",
      "value" => "10.00",
      "start_datetime" => "2016-01-01",
      "end_datetime" => "2020-01-01",
    }}))
    response = Controller.handle_request(request, [])
    redirect = Raxx.Patch.follow(response)
    assert {%{success: "Discount created"}, _request} = UM.Web.Flash.from_request(redirect)
    assert ["admin", "discounts", id, "edit"] = redirect.path
    assert {:ok, %{code: "MYCODE23", value: 1000}} = UM.Sales.Discounts.fetch_by_id(id)
  end

  test "edit page is available" do
    discount = %{code: code, id: id} = UM.Web.Fixtures.test_discount
    request = get("/#{id}/edit")
    response = Controller.handle_request(request, [])
    assert 200 == response.status
    assert String.contains?(response.body, code)
  end

  test "can update a discount" do
    discount = %{code: code, id: id} = UM.Web.Fixtures.test_discount
    request = put("/#{id}", form_data(%{"discount" => %{
      "code" => code,
      "allocation" => "100",
      "customer_allocation" => "1",
      "value" => "9.00",
      "start_datetime" => "2016-01-01",
      "end_datetime" => "2020-01-01",
    }}))
    response = Controller.handle_request(request, [])
    redirect = Raxx.Patch.follow(response)
    assert {%{success: "Discount updated"}, _request} = UM.Web.Flash.from_request(redirect)
    assert ["admin", "discounts", id, "edit"] = redirect.path
    assert {:ok, %{value: 900}} = UM.Sales.Discounts.fetch_by_id(id)
  end

  # DEBT cannot delete code, just set run date to past date.
end