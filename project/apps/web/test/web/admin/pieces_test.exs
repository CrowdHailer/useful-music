defmodule UM.Web.Admin.PiecesTest do
  use ExUnit.Case, async: true
  alias UM.Web.Admin.Pieces

  import Raxx.Test

  test "index page shows all pieces" do
    request = get("/")
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "UM100")
  end

  test "can search for a piece by id" do
    request = get({"/search", %{"search" => "123"}})
    %{status: status, headers: headers} = Pieces.handle_request(request, %{})
    assert 302 == status
    assert {"location", "/admin/pieces/UD123/edit"} == List.keyfind(headers, "location", 0)
  end

  test "can search for a piece by catalogue_number" do
    request = get({"/search", %{"search" => "UD123"}})
    %{status: status, headers: headers} = Pieces.handle_request(request, %{})
    assert 302 == status
    assert {"location", "/admin/pieces/UD123/edit"} == List.keyfind(headers, "location", 0)
  end

  test "can visit new piece page" do
    request = get("/new")
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "New Piece")
  end

  test "can create a new piece" do
    request = post("/", form_data(%{
      piece: %{
        id: "123",
        title: "A piece of music",
        sub_heading: "flute and claranet",
        level_overview: "1 to 3",
        description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      }
    }))
    %{status: status, headers: headers} = Pieces.handle_request(request, %{})
    assert 302 == status
    assert {"location", "/admin/pieces"} == List.keyfind(headers, "location", 0)
  end

  test "cant create a piece without id" do
    request = post("/", form_data(%{
      piece: %{
        id: "",
        title: "A piece of music",
        sub_heading: "flute and claranet",
        level_overview: "1 to 3",
        description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      }
    }))
    %{status: status, headers: headers} = Pieces.handle_request(request, %{})
    assert 302 == status
    assert {"location", "/admin/pieces/new"} == List.keyfind(headers, "location", 0)
  end

  test "cant create a piece with existing id" do
    request = post("/", form_data(%{
      piece: %{
        id: "100",
        title: "A piece of music",
        sub_heading: "flute and claranet",
        level_overview: "1 to 3",
        description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      }
    }))
    %{status: status, headers: headers} = Pieces.handle_request(request, %{})
    assert 302 == status
    assert {"location", "/admin/pieces/new"} == List.keyfind(headers, "location", 0)
  end
end
