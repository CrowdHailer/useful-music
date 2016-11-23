defmodule UM.Web.Admin.PiecesTest do
  use ExUnit.Case, async: true
  alias UM.Web.Admin.Pieces

  test "index page shows all pieces" do
    request = %Raxx.Request{path: []}
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "UM100")
  end

  test "can search for a piece by id" do
    request = %Raxx.Request{
      path: ["search"],
      query: %{"search" => "123"}
    }
    %{status: status, headers: headers} = Pieces.handle_request(request, %{})
    assert 302 == status
    assert {"location", "/admin/pieces/UD123/edit"} == List.keyfind(headers, "location", 0)
  end

  test "can search for a piece by catalogue_number" do
    request = %Raxx.Request{
      path: ["search"],
      query: %{"search" => "UD123"}
    }
    %{status: status, headers: headers} = Pieces.handle_request(request, %{})
    assert 302 == status
    assert {"location", "/admin/pieces/UD123/edit"} == List.keyfind(headers, "location", 0)
  end

  test "can visit new piece page" do
    request = %Raxx.Request{path: ["new"]}
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "New Piece")
  end
end
