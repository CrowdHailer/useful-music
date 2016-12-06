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
    # |> IO.inspect
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    {:ok, %{id: _id}} = Catalogue.create_piece(@canonical_piece)
  end


  # The form field for piece id is a number field.
  # ID is an integer
  # Catalogue number is formed as `"UM#{id}"`
  # Validations for fields are all relying on the DB
  test "can create a new piece" do
    {:ok, piece} = Catalogue.create_piece(%{@canonical_piece | id: 205, title: "Something new" })

    assert "UD205" == Catalogue.Piece.catalogue_number(piece)
    assert "Something new" == piece.title
  end

  test "can not create a piece with duplicate id" do
    assert {:error, :id_already_used} = Catalogue.create_piece(@canonical_piece)
  end

  test "will not create an invalid piece" do
    assert {:error, _} = Catalogue.create_piece(%{id: nil})
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
    piece = %{piece | advanced: true}
    {:ok, _piece} = Catalogue.update_piece(piece)
  end

  test "cannot update a piece to be invalid", %{id: id} do
    {:ok, piece} = Catalogue.fetch_piece(id)
    piece = %{piece | title: nil}
    {:error, :invalid_piece} = Catalogue.update_piece(piece)
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
      # make item struct
      id: nil,
      name: "the other piece",
      initial_price: 60,
      asset: "link I dont have again",
      piece_id: piece_id
    })
    assert item.id
  end

  test "can update an item", %{id: piece_id} do
    # alternative signature (%{id: piece_id}, item)
    {:ok, item} = Catalogue.create_item(%{
      # make item struct
      id: nil,
      name: "the other piece",
      initial_price: 60,
      asset: "link I dont have again",
      piece_id: piece_id
    })
    {:ok, item} = Catalogue.fetch_item(item.id)
    item = %{item | initial_price: 100}
    {:ok, _item} = Catalogue.update_item(item)
  end

  test "can load the items associated with a piece", %{id: piece_id} do
    {:ok, _item} = Catalogue.create_item(%{
      # make item struct
      id: nil,
      name: "violin piece",
      initial_price: 60,
      asset: "link I dont have again",
      piece_id: piece_id
      })
    {:ok, _item} = Catalogue.create_item(%{
      # make item struct
      id: nil,
      name: "violin piece",
      initial_price: 60,
      asset: "link I dont have again",
      piece_id: piece_id
      })
    {:ok, piece} = Catalogue.fetch_piece(piece_id)
    {:ok, piece} = Catalogue.load_items(piece)
    assert 2 = Enum.count(piece.items)
  end
end
