defmodule UM.Web.Admin.PiecesTest do
  use ExUnit.Case
  alias UM.Web.Admin.Pieces
  alias UM.Catalogue

  import Raxx.Test

  # This is a horrible duplication
  @canonical_piece %{
    id: 101,
    title: "Canonical Piece",
    sub_heading: "The very first piece",
    description: "I uses this piece for testing all the flipping time",
    level_overview: "not that easy",
    notation_preview: "A link which I don't yet have"}

  setup do
    Moebius.Query.db(:purchases) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    {:ok, %{id: _id}} = Catalogue.create_piece(@canonical_piece)
  end

  test "index page shows all pieces" do
    request = get("/")
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "UM101")
  end

  test "can search for a piece by id" do
    request = get({"/search", %{"search" => "123"}})
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces/UD123/edit" == Raxx.Patch.response_location(response)
  end

  test "can search for a piece by catalogue_number" do
    request = get({"/search", %{"search" => "UD123"}})
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces/UD123/edit" == Raxx.Patch.response_location(response)
  end

  test "can visit new piece page" do
    request = get("/new")
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "New Piece")
  end

  test "can create a new piece" do
    # can post file using httpoison
    request = post("/", form_data(%{
      piece: %{@canonical_piece | id: "123"}
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces" == Raxx.Patch.response_location(response)
    assert {:ok, _piece} = Catalogue.fetch_piece(123)
  end

  test "cant create a piece without id" do
    request = post("/", form_data(%{
      piece: %{@canonical_piece | id: ""}
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces/new" == Raxx.Patch.response_location(response)
  end

  test "cant create a piece with existing id" do
    request = post("/", form_data(%{
      piece: @canonical_piece
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces/UD101/edit" == Raxx.Patch.response_location(response)
  end
end
