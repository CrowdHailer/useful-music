defmodule UM.Catalogue do
  alias UM.Catalogue.Piece

  @fixtures %{
    100 => %Piece{
      title: "First Piece"
    }
  }
  # TODO call db
  def create_piece(piece = %{id: id}) when is_integer(id) do
    case Map.get(@fixtures, id) do
      nil ->
        # TODO modify fixtures
        {:ok, piece}
      piece ->
        {:error, :id_already_used}
    end
  end

  def create_piece(_) do
    {:error, :invalid_piece}
  end

  def fetch_piece(id) do
    case Map.fetch(@fixtures, id) do
      {:ok, piece} ->
        {:ok, piece}
      :error ->
        {:error, :piece_not_found}
    end
  end
end
