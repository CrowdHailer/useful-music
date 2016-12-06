defmodule Um.Web.Admin.ItemsControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Web.Admin.ItemsController, as: Controller
  alias UM.Catalogue

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

  test "new item page is available", %{piece: piece} do
    request = get({"/new", %{"piece_id" => piece.id}})
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "UD#{piece.id}")
  end

  test "successful item creation", %{piece: piece} do
    request = post("/", %{
      "item" => %{
        "name" => "Flute part",
        "piece_id" => "#{piece.id}",
        "initial_price" => "40",
        "discounted_price" => "20",
        "asset" => %Raxx.Upload{filename: "bob.png", content: "hello world"},
    }})
    response = Controller.handle_request(request, :nostate)
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "Item+created")
    assert String.contains?(location, UM.Catalogue.Piece.catalogue_number(piece))
    # DEBT better flash testing
  end

  test "item edit page is available", %{piece: piece} do
    {:ok, item} = UM.Catalogue.create_item(%{
      piece_id: piece.id,
      name: "This piece",
      asset: "somefile.mp3",
      initial_price: 40
    })
    request = get("/#{item.id}/edit")
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "value=\"This piece\"")
  end
end