defmodule UM.Catalogue.PiecesRepo do
  import Moebius.Query

  # pieces table does not have `created_at` and `updated_at` columns.
  def insert(piece = %{id: id}) do
    piece = pack(piece)
    piece = Enum.map(piece, fn(x) -> x end)

    action = db(:pieces) |> insert(piece)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, unpack(record)}
      # DEBT exatch matching
      {:error, "duplicate key value violates unique constraint \"pieces_pkey\""} ->
        {:error, :id_already_used}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def pack(piece) do
    piece
  end

  def unpack(record) do
    record
  end
end
