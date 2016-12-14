defmodule PieceStorage do
  use Arc.Definition

   def __storage, do: Arc.Storage.Local # Add this

  def storage_dir(:original, {file, %{id: id}}) do
    "uploads/pieces/UD#{id}"
  end
end

defmodule UM.Catalogue do
  # Also named Inventory
  import Moebius.Query

  def tags do
    UM.Catalogue.Piece.all_instruments ++
    UM.Catalogue.Piece.all_levels ++
    UM.Catalogue.Piece.all_categories
  end

  def create_piece(piece = %{id: id}) do
    # DEBT insert requires a keyword list
    piece = case Map.pop(piece, :notation_preview) do
      {%Raxx.Upload{content: c, filename: filename}, piece} ->
        # {:ok, filename} = Arc.Storage.Local.put(PieceStorage, 1, {Arc.File.new(%{filename: "noop.txt", binary: c}), %{id: id}})
        # The filename should not be from the client. It is only rewritten for each version, i.e. thumbnails
        # take ext from upload
        filename = "UD#{id}_notation_preview" <> Path.extname(filename)

        {:ok, filename} = PieceStorage.store({%{filename: filename, binary: c}, %{id: id}})
        Map.merge(piece, %{notation_preview: filename})
      {nil, piece} ->
        piece
    end
    piece = case Map.pop(piece, :cover_image) do
      {_, piece} ->
        piece
    end
    piece = case Map.pop(piece, :audio_preview) do
      {_, piece} ->
        piece
    end
    # IO.inspect(piece)
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
    # |> IO.inspect
  end

  def fetch_piece(id) do
    query = db(:pieces) |> filter(id: id)
    case Moebius.Db.first(query) do
      nil -> {:error, :piece_not_found}
      piece -> {:ok, piece}
    end
  end

  def update_piece(piece = %{id: id}) when is_integer(id) do
    # DEBT insert requires a keyword list
    piece = Enum.map(piece, fn(x) -> x end)
    |> Enum.filter(fn
      ({_, :file_not_provided}) -> false
      (_) -> true
    end)

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
      tags ->
        db(:pieces)
        |> filter(tags)
    end

    # TODO this should load all the items as well
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

  def create_item(item) do
    # DEBT insert requires a keyword list
    nil = Map.get(item, :id)
    item = Map.put(item, :id, random_string(16))
    item = Enum.map(item, fn(x) -> x end)

    item = case Map.pop(item, :asset) do
      {%Raxx.Upload{content: c, filename: filename}, piece} ->
        # {:ok, filename} = Arc.Storage.Local.put(PieceStorage, 1, {Arc.File.new(%{filename: "noop.txt", binary: c}), %{id: id}})
        # The filename should not be from the client. It is only rewritten for each version, i.e. thumbnails
        # take ext from upload


        # TODO save create an assets uploader
        # {:ok, filename} = PieceStorage.store({%{filename: filename, binary: c}, %{id: id}})
        Map.merge(piece, %{asset: filename})
      {nil, item} ->
        item
    end

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
    # DEBT insert requires a keyword list
    item = Enum.map(item, fn(x) -> x end)
    |> Enum.filter(fn
      ({_, :file_not_provided}) -> false
      (_) -> true
    end)

    action = db(:items)
      |> filter(id: id)
      |> update(item)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, record}
      {:error, _reason} ->
        {:error, :invalid_item}
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

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  # FIXME remove
  def load_fixtures do
    piece = %{
      id: 101,
      title: "Canonical Piece",
      sub_heading: "The very first piece",
      description: "I uses this piece for testing all the flipping time",
      level_overview: "not that easy",
      notation_preview: %Raxx.Upload{content: "Hello, World!", filename: "hello.txt"}}
    {:ok, %{id: piece_id}} = create_piece(piece)
    {:ok, item} = create_item(%{
      # make item struct
      id: nil,
      name: "the other piece",
      initial_price: 60,
      asset: "link I dont have again",
      piece_id: piece_id
    })
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
