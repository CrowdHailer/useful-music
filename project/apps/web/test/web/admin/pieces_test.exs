defmodule UM.Web.Admin.PiecesTest do
  use ExUnit.Case, async: true
  alias UM.Web.Admin.Pieces

  test "index page shows all pieces" do
    request = %Raxx.Request{path: []}
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "UM100")
  end
end
