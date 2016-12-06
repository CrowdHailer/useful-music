defmodule UM.Catalogue.PieceTest do
  use ExUnit.Case
  alias UM.Catalogue.Piece

  test "piece has catalogue_number" do
    assert "UD213" == %Piece{id: 213} |> Piece.catalogue_number
  end

  test "piece has a product name" do
    assert "The Fox - in C" == %Piece{title: "The Fox", sub_heading: "in C"} |> Piece.product_name
  end

  test "can list all categories the piece belongs too" do
    piece = %Piece{duet: true, trio: true}
    assert [:duet, :trio] == Piece.categories(piece)
  end

  test "can list all instruments that a piece has" do
    piece = %Piece{piano: true, oboe: true}
    assert [:piano, :oboe] == Piece.instruments(piece)
  end

  test "can list all levels a piece is suitable for" do
    piece = %Piece{beginner: true}
    assert [:beginner] == Piece.levels(piece)
  end
end
