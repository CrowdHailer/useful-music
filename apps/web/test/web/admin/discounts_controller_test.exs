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
end
