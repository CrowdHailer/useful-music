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
    notation_preview: %Raxx.Upload{
      content: "My Upload document"
    }}

  setup do
    Moebius.Query.db(:purchases) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    piece = @canonical_piece
    {:ok, %{id: _id}} = Catalogue.create_piece(piece)
  end

  test "index page shows all pieces" do
    request = get("/")
    %{status: status, body: body} = Pieces.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "UD101")
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
    piece = %{@canonical_piece | id: "123", notation_preview: %Raxx.Upload{content: "Hello", filename: "blob.pdf"}}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = post("/", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces" == Raxx.Patch.response_location(response)
    assert {:ok, _piece} = Catalogue.fetch_piece(123)
  end

  test "cant create a piece without id" do
    piece = %{@canonical_piece | id: "", notation_preview: nil}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = post("/", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces/new" == Raxx.Patch.response_location(response)
  end

  test "cant create a piece with existing id (redirects to piece)" do
    piece = %{@canonical_piece | id: "101"}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = post("/", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces/UD101/edit" == Raxx.Patch.response_location(response)
  end

  test "can visit a pieces edit page" do
    request = get("/UD#{@canonical_piece.id}/edit")
    response = Pieces.handle_request(request, %{})
    assert 200 == response.status
  end

  test "trying to edit a non existant piece results in a 404" do
    request = get("/UD999/edit")
    response = Pieces.handle_request(request, %{})
    assert 404 == response.status
    assert String.contains?(response.body, "UD999")
  end

  test "can update a piece" do
    piece = %{@canonical_piece | title: "The new hotness", notation_preview: nil, id: "101"}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = post("/UD101", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    assert "/admin/pieces/UD101/edit" == Raxx.Patch.response_location(response)
  end

  # DEBT Flash messages on Create and update
  # DEBT Lost information on failed form submission
  # DEBT Do not have the ability to delete pieces
end
