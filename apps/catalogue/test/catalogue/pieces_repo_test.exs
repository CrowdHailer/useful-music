defmodule UM.Catalogue.PiecesRepoTest do
  use ExUnit.Case
  alias UM.Catalogue.Piece

  defp canonical_piece do
    %{id: 101,
    title: "Canonical Piece",
    sub_heading: "The very first piece",
    description: "I uses this piece for testing all the flipping time",
    level_overview: "not that easy",
    notation_preview: "UD101_notation_preview.pdf"}
  end
end
