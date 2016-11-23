defmodule UM.Catalogue do
  alias UM.Catalogue.Piece
  # TODO call db
  def create_piece(piece) do

    {:ok, piece}
  end

  def fetch_piece(id) do
    case id do
      100 -> {:ok, %Piece{id: id, title: "First Piece"}}
      _ -> {:error, :piece_not_found} # TODO create an error object with the attempted id
    end
  end
end
