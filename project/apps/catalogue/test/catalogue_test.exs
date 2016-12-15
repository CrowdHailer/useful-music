defmodule UM.CatalogueTest do
  use ExUnit.Case
  alias UM.Catalogue

  @canonical_piece %{
    id: 101,
    title: "Canonical Piece",
    sub_heading: "The very first piece",
    description: "I uses this piece for testing all the flipping time",
    level_overview: "not that easy",
    notation_preview: %Raxx.Upload{content: "Hello, World!", filename: "hello.txt"}}

  setup do
    Moebius.Query.db(:purchases) |> Moebius.Query.delete |> Moebius.Db.run
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run
    {:ok, %{id: _id}} = Catalogue.create_piece(@canonical_piece)
  end

  test "can create a new piece" do
    {:ok, piece} = Catalogue.create_piece(Map.merge(@canonical_piece, %{
      id: 205,
      title: "Something new",
      notation_preview: %Raxx.Upload{content: "Hello, World!", filename: "hello.pdf"},
      cover_image: %Raxx.Upload{content: "A pretty picture", filename: "pic.jpg"},
      audio_preview: %Raxx.Upload{content: "Lovely tunes", filename: "sound.mp3"},
    }))

    assert "UD205" == Catalogue.Piece.catalogue_number(piece)
    assert "Something new" == piece.title
    assert "UD205_notation_preview.pdf" == piece.notation_preview
    assert "UD205_cover_image.jpg" == piece.cover_image
    assert "UD205_audio_preview.mp3" == piece.audio_preview
  end

  test "can not create a piece with duplicate id" do
    assert {:error, :id_already_used} = Catalogue.create_piece(@canonical_piece)
  end

  test "will not create an invalid piece" do
    assert {:error, reason} = Catalogue.create_piece(%{id: nil})
    assert reason == "null value in column \"id\" violates not-null constraint"
  end

  test "can fetch a piece by id", %{id: id} do
    {:ok, piece} = Catalogue.fetch_piece(id)
    assert "Canonical Piece" == piece.title
  end

  test "get an error when fetching a missing piece" do
    assert {:error, :piece_not_found} == Catalogue.fetch_piece(10)
  end

  test "can update a piece", %{id: id} do
    {:ok, piece} = Catalogue.fetch_piece(id)
    piece = %{piece | advanced: true, cover_image: %Raxx.Upload{content: "A pretty picture", filename: "pic.jpg"}}
    {:ok, _piece} = Catalogue.update_piece(piece)
    assert {:ok, piece = %{advanced: true}} = Catalogue.fetch_piece(id)
    assert "UD101_cover_image.jpg" == piece.cover_image
  end

  test "cannot update a piece to be invalid", %{id: id} do
    {:ok, piece} = Catalogue.fetch_piece(id)
    piece = %{piece | title: nil}
    assert {:error, _reason} = Catalogue.update_piece(piece)
  end

  # TODO delete piece

  test "fetch a list of all pieces" do
    {:ok, [piece]} = Catalogue.search_pieces()
    assert 101 = piece.id
  end

  # TODO start catalogue with a few items
  test "can create a new item", %{id: piece_id} do
    # alternative signature (%{id: piece_id}, item)
    {:ok, item} = Catalogue.create_item(%{
      name: "audio",
      initial_price: 60,
      asset: %{content: "some sounds", filename: "music.mp3"},
      piece_id: piece_id
    })
    assert item.id
    assert "UD101_audio.mp3" == item.asset
  end

  test "can update an item", %{id: piece_id} do
    # alternative signature (%{id: piece_id}, item)
    {:ok, item} = Catalogue.create_item(%{
      name: "audio",
      initial_price: 60,
      asset: %{content: "some sounds", filename: "music.mp3"},
      piece_id: piece_id
    })
    {:ok, item} = Catalogue.fetch_item(item.id)
    item = %{item | initial_price: 100, name: "flute part", asset: %{content: "some picture", filename: "picture.jpg"}}
    {:ok, _item} = Catalogue.update_item(item)
    {:ok, item} = Catalogue.fetch_item(item.id)
    assert 100 == item.initial_price
    assert "UD101_flute_part.jpg" == item.asset
    assert "/uploads/pieces/UD101/items/UD101_flute_part.jpg" == UM.Catalogue.ItemStorage.url({item.asset, item})

  end

  test "can load the items associated with a piece", %{id: piece_id} do
    {:ok, _item} = Catalogue.create_item(%{
      name: "violin piece",
      initial_price: 60,
      asset: %{content: "some sounds", filename: "music.mp3"},
      piece_id: piece_id
      })
    {:ok, _item} = Catalogue.create_item(%{
      name: "flute piece",
      initial_price: 60,
      asset: %{content: "some sounds", filename: "music.mp3"},
      piece_id: piece_id
      })
    {:ok, piece} = Catalogue.fetch_piece(piece_id)
    {:ok, piece} = Catalogue.load_items(piece)
    assert 2 = Enum.count(piece.items)
  end

  test "searching" do
    piece = Map.merge(@canonical_piece, %{id: 102, beginner: true, solo: true, trumpet: true})
    {:ok, _} = Catalogue.create_piece(piece)
    piece = Map.merge(@canonical_piece, %{id: 103, advanced: true, solo: true, trumpet: true})
    {:ok, _} = Catalogue.create_piece(piece)
    piece = Map.merge(@canonical_piece, %{id: 104, advanced: true, solo: true, violin: true})
    {:ok, _} = Catalogue.create_piece(piece)
    {:ok, [_,_,_,_]} = Catalogue.search_pieces
    {:ok, [_, _]} = Catalogue.search_pieces(%{advanced: true})
    {:ok, [_]} = Catalogue.search_pieces(%{advanced: true, violin: true})
  end

  test "searching titles" do
    piece = Map.merge(@canonical_piece, %{id: 102, title: "The big folly"})
    {:ok, _} = Catalogue.create_piece(piece)
    piece = Map.merge(@canonical_piece, %{id: 103, title: "The BIG folly James"})
    {:ok, _} = Catalogue.create_piece(piece)
    piece = Map.merge(@canonical_piece, %{id: 104, title: "The small folly"})
    {:ok, _} = Catalogue.create_piece(piece)
    {:ok, [_,_,]} = Catalogue.search_title("big folly")
  end
end
