defmodule UM.Web.Admin.CustomersTest do
  use ExUnit.Case, async: true
  alias UM.Web.Admin.Customers

  import Raxx.Test

  test "index page shows customer" do
    request = get("/")
    response = Customers.handle_request(request, :nostate)
    assert String.contains?(response.body, "issac")
  end
end
