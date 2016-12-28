defmodule UM.Catalogue do
  import Moebius.Query
  alias UM.Catalogue.{PieceStorage, ItemStorage}

  def tags do
    UM.Catalogue.Piece.all_instruments ++
    UM.Catalogue.Piece.all_levels ++
    UM.Catalogue.Piece.all_categories
  end

  def save_piece_assets(piece) do
    piece = case Map.pop(piece, :notation_preview) do
      {in_memory = %{content: _, filename: _}, piece} ->
        {:ok, filename} = PieceStorage.save_notation_preview(in_memory, piece)
        Map.merge(piece, %{notation_preview: filename})
      {nil, piece} ->
        piece
      {filename, piece} when is_binary(filename) ->
        Map.put(piece, :notation_preview, filename)
    end
    piece = case Map.pop(piece, :cover_image) do
      {in_memory = %{content: _, filename: _}, piece} ->
        {:ok, filename} = PieceStorage.save_cover_image(in_memory, piece)
        Map.merge(piece, %{cover_image: filename})
      {nil, piece} ->
        piece
      {filename, piece} when is_binary(filename) ->
        Map.put(piece, :cover_image, filename)
    end
    piece = case Map.pop(piece, :audio_preview) do
      {in_memory = %{content: _, filename: _}, piece} ->
        {:ok, filename} = PieceStorage.save_audio_preview(in_memory, piece)
        Map.merge(piece, %{audio_preview: filename})
      {nil, piece} ->
        piece
      {filename, piece} when is_binary(filename) ->
        Map.put(piece, :audio_preview, filename)
    end
    piece
  end

  def create_piece(piece = %{id: id}) do
    piece = save_piece_assets(piece)
    piece = Enum.map(piece, fn(x) -> x end)

    action = db(:pieces) |> insert(piece)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, record}
      # DEBT exatch matching
      {:error, "duplicate key value violates unique constraint \"pieces_pkey\""} ->
        {:error, :id_already_used}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def fetch_piece(id) do
    query = db(:pieces) |> filter(id: id)
    case Moebius.Db.first(query) do
      nil -> {:error, :piece_not_found}
      piece -> {:ok, piece}
    end
  end

  def update_piece(piece = %{id: id}) when is_integer(id) do
    piece = save_piece_assets(piece)
    # DEBT insert requires a keyword list
    piece = Enum.map(piece, fn(x) -> x end)

    action = db(:pieces)
    |> filter(id: id)
    |> update(piece)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, record}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def delete_piece(id) do
    action = db(:pieces)
    |> filter(id: id)
    |> delete
    case Moebius.Db.run(action) do
      %{deleted: 1} ->
        {:ok, id}
    end
  end

  def search_pieces(tags \\ %{}) do
    tags = Enum.flat_map(tags, fn
      ({key, true}) ->
        [{key, true}]
      ({_key, false}) ->
        []
    end)

    query = case tags do
      [] ->
        db(:pieces)
        |> sort(:id, :asc)
      tags ->
        db(:pieces)
        |> sort(:id, :asc)
        |> filter(tags)
    end
    {:ok, Moebius.Db.run(query)}
  end

  def random_pieces(4) do
    {:ok, Moebius.Db.run("SELECT * FROM pieces ORDER BY RANDOM() LIMIT 4")}
  end

  def search_title(title) do
    query = db(:pieces)
    |> filter("title ILIKE $1", "%#{title}%")

    {:ok, Moebius.Db.run(query)}
  end

  def save_item_assets(item) do
    case Map.pop(item, :asset) do
      {in_memory = %{content: _, filename: _}, item} ->
        {:ok, filename} = ItemStorage.save_asset(in_memory, item)
        Map.merge(item, %{asset: filename})
      {nil, item} ->
        item
      {filename, item} when is_binary(filename) ->
        Map.put(item, :asset, filename)
    end
  end

  def create_item(item) do
    # DEBT insert requires a keyword list
    nil = Map.get(item, :id)
    item = Map.put(item, :id, Utils.random_string(16))

    item = save_item_assets(item)

    item = Enum.map(item, fn(x) -> x end)

    action = db(:items) |> insert(item)
    case Moebius.Db.run(action) do
      record = %{id: _id} ->
        {:ok, record}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def fetch_item(id) do
    query = db(:items) |> filter(id: id)
    case Moebius.Db.first(query) do
      nil -> {:error, :item_not_found}
      item -> {:ok, item}
    end
  end

  def update_item(item = %{id: id}) do
    item = save_item_assets(item)

    # DEBT insert requires a keyword list
    item = Enum.map(item, fn(x) -> x end)

    action = db(:items)
      |> filter(id: id)
      |> update(item)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, record}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def delete_item(id) do
    action = db(:items)
    |> filter(id: id)
    |> delete
    case Moebius.Db.run(action) do
      %{deleted: 1} ->
        {:ok, id}
    end
  end

  def load_items(piece = %{id: piece_id}) do
    query = db(:items) |> filter(piece_id: piece_id)
    items = Moebius.Db.run(query)
    {:ok, Map.merge(piece, %{items: items})}
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
