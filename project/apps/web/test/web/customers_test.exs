defmodule UM.Web.CustomersTest do
  use ExUnit.Case, async: true

  import Raxx.Test

  alias UM.Web.Customers, as: Controller

  test "new page is available" do
    request = get("/new")
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
  end
end
