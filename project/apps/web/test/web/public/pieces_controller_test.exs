defmodule UM.Web.PiecesControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Catalogue
  alias UM.Web.PiecesController, as: Controller
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
    {:ok, piece} = Catalogue.create_piece(piece)
    {:ok, %{piece: piece}}
  end

  test "index page shows all pieces" do
    request = get("/")
    %{status: status, body: body} = Controller.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "UD101")
    assert String.contains?(body, "Canonical Piece")
  end

  test "searches on title" do
    request = get({"/search", %{search: "Canonical"}})
    response = Controller.handle_request(request, %{})
    assert 200 == response.status
    assert String.contains?(response.body, "UD101")
    assert String.contains?(response.body, "Canonical Piece")
  end

  test "redirects to show page for catalogue number" do
    request = get({"/search", %{search: "UD123"}})
    response = Controller.handle_request(request, %{})
    assert 302 == response.status
    assert "/pieces/UD123" == Raxx.Patch.response_location(response)
  end

  test "show page is viewable", %{piece: piece} do
    request = get("/UD#{piece.id}")
    response = Controller.handle_request(request, %{})
    assert 200 == response.status
    assert String.contains?(response.body, "UD101")
    assert String.contains?(response.body, "Canonical Piece")
  end

  test "redirects from missing piece page" do
    request = get("/UD999")
    response = Controller.handle_request(request, %{})
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/pieces")
    assert String.contains?(location, "Piece+not+found")
  end
end
