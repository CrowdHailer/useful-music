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
    {:ok, %{id: _id}} = Catalogue.create_piece(piece)
  end

  test "index page shows all pieces" do
    request = get("/")
    %{status: status, body: body} = Controller.handle_request(request, %{})
    assert 200 == status
    assert String.contains?(body, "UD101")
    assert String.contains?(body, "Canonical Piece")
  end
end
