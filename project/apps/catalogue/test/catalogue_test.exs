defmodule UM.CatalogueTest do
  use ExUnit.Case
  alias UM.Catalogue

  setup do
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run
    :ok
  end

  @canonical_piece %{
    id: 101,
    title: "Canonical Piece",
    sub_heading: "The very first piece",
    description: "I uses this piece for testing all the flipping time",
    level_overview: "not that easy",
    notation_preview: "A link which I don't yet have"}

  # The form field for piece id is a number field.
  # ID is an integer
  # Catalogue number is formed as `"UM#{id}"`
  # Validations for fields are all relying on the DB
  test "can create a new piece" do
    {:ok, piece} = Catalogue.create_piece(@canonical_piece)

    assert "UM101" == Catalogue.Piece.catalogue_number(piece)
  end

  test "can not create a piece with duplicate id" do
    # In future test against fixture
    {:ok, piece} = Catalogue.create_piece(@canonical_piece)
    assert {:error, :id_already_used} = Catalogue.create_piece(@canonical_piece)
  end

  test "will not create an invalid piece" do
    assert {:error, :invalid_piece} = Catalogue.create_piece(%{id: nil})
  end

  test "can fetch a piece by id" do
    {:ok, %{id: id}} = Catalogue.create_piece(@canonical_piece)
    {:ok, piece} = Catalogue.fetch_piece(id)
    assert "Canonical Piece" == piece.title
  end

  test "get an error when fetching a missing piece" do
    assert {:error, :piece_not_found} == Catalogue.fetch_piece(10)
  end
end
