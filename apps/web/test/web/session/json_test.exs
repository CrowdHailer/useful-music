defmodule UM.Web.Session.JSONTest do
  use ExUnit.Case

  alias UM.Web.Session

  test "unauthenticated currency preference is saved" do
    original = Session.new |> Session.select_currency("USD")
    loaded = Session.JSON.encode!(original) |> Session.JSON.decode
    assert original == loaded
  end
end
