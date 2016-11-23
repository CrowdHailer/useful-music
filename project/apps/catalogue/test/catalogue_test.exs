defmodule UM.CatalogueTest do
  use ExUnit.Case
  alias UM.Catalogue

  # The form field for piece id is a number field.
  # ID is an integer
  # Catalogue number is formed as `"UM#{id}"`
  # Validations for fields are all relying on the DB
  test "can create a new piece" do
    {:ok, piece} = Catalogue.create_piece(%{id: 101})
    assert "UM101" == Catalogue.Piece.catalogue_number(piece)
  end

  test "can not create a piece with duplicate id" do
    assert {:error, :id_already_used} = Catalogue.create_piece(%{id: 100})
  end

  test "will not create an invalid piece" do
    assert {:error, :invalid_piece} = Catalogue.create_piece(%{id: nil})
  end

  test "can fetch a piece by id" do
    {:ok, piece} = Catalogue.fetch_piece(100)
    assert "First Piece" == piece.title
  end

  test "get an error when fetching a missing piece" do
    assert {:error, :piece_not_found} == Catalogue.fetch_piece(101)
  end
end
