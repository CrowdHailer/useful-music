defmodule UM.Catalogue do
  # Also named Inventory
  alias UM.Catalogue.Piece
  import Moebius.Query

  def create_piece(piece = %{id: id}) do
    # DEBT insert requires a keyword list
    piece = Enum.map(piece, fn(x) -> x end)
    action = db(:pieces) |> insert(piece)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, record}
      # DEBT exatch matching
      {:error, "duplicate key value violates unique constraint \"pieces_pkey\""} ->
        {:error, :id_already_used}
      {:error, _reason} ->
        {:error, :invalid_piece}
    end
  end

  def fetch_piece(id) do
    query = db(:pieces) |> filter(id: id)
    case Moebius.Db.first(query) do
      nil -> {:error, :piece_not_found}
      piece -> {:ok, piece}
    end
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Moebius.Db, [Moebius.get_connection]),
    ]

    opts = [strategy: :one_for_one, name: UM.Catalogue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
