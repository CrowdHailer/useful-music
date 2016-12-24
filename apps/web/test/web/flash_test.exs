defmodule UM.Web.FlashTest do
  alias UM.Web.Flash
  use ExUnit.Case, async: true

  import Raxx.Request

  test "returns empty flash from request with no query" do
    request = get("/")

    {flash, _request} = Flash.from_request(request)
    assert %Flash{error: nil, success: nil} == flash
  end

  test "returns empty flash when query is invalid" do
    request = get({"/", %{flash: "not JSON {at all}"}})

    {flash, _request} = Flash.from_request(request)
    assert %Flash{error: nil, success: nil} == flash
  end

  test "removes the flash from a request query" do
    request = get({"/", %{"flash" => Poison.encode!(%{error: "There was some error"})}})

    {flash, request} = Flash.from_request(request)
    refute Map.get(request.query, "flash")
    assert %Flash{error: "There was some error", success: nil} == flash
  end
end
