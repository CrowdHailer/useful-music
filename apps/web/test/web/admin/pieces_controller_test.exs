defmodule UM.Web.Admin.PiecesControllerTest do
  use ExUnit.Case
  alias UM.Web.Admin.PiecesController
  alias UM.Catalogue

  import Raxx.Test

  setup do
    :ok = UM.Web.Fixtures.clear_db
  end

  test "index page shows all pieces" do
    _piece = UM.Web.Fixtures.canonical_piece
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
    piece = UM.Web.Fixtures.canonical_piece
    piece = %{piece | id: "123", notation_preview: %Raxx.Upload{content: "Hello", filename: "blob.pdf"}}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = post("/", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert {:ok, _piece} = Catalogue.fetch_piece(123)
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces")
    assert String.contains?(location, "Piece+created")
  end

  test "can't create a piece without id" do
    piece = UM.Web.Fixtures.canonical_piece
    piece = %{piece | id: "", notation_preview: nil}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = post("/", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces/new")
    assert String.contains?(location, "Could+not+create+invalid+piece")
  end

  test "can't create a piece with existing id (redirects to piece)" do
    piece = UM.Web.Fixtures.canonical_piece
    # DEBT this overwrites files of the currenct piece
    piece = %{piece | id: "101", notation_preview: %Raxx.Upload{content: "ss", filename: "billy.jpg"}}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = post("/", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces/UD101/edit")
    assert String.contains?(location, "UD101+already+exists")
  end

  test "can visit a pieces edit page" do
    piece = UM.Web.Fixtures.canonical_piece
    request = get("/UD#{piece.id}/edit")
    response = Pieces.handle_request(request, %{})
    assert 200 == response.status
    assert String.contains?(response.body, "UD101")
  end

  test "trying to edit a non existant piece results in a 404" do
    request = get("/UD999/edit")
    response = Pieces.handle_request(request, %{})
    assert 404 == response.status
    assert String.contains?(response.body, "UD999")
  end

  test "can update a piece" do
    piece = UM.Web.Fixtures.canonical_piece
    piece = %{piece | title: "The new hotness", id: "101", notation_preview: %Raxx.Upload{content: ""}}
    piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}
    request = put("/UD101", form_data(%{
      "piece" => piece
    }))
    response = Pieces.handle_request(request, %{})
    assert {:ok, %{title: "The new hotness"}} = Catalogue.fetch_piece(101)
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces/UD101/edit")
    assert String.contains?(location, "Piece+updated")
  end

  test "can delete a piece" do
    piece = UM.Web.Fixtures.canonical_piece
    request = delete("/UD101")
    response = Pieces.handle_request(request, %{})
    assert {:error, :piece_not_found} = Catalogue.fetch_piece(101)
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces")
    assert String.contains?(location, "Piece+deleted")
  end
end
