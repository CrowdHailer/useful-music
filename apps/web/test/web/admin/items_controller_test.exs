defmodule Um.Web.Admin.ItemsControllerTest do
  use ExUnit.Case
  import Raxx.Request

  alias UM.Web.Admin.ItemsController, as: Controller
  alias UM.Catalogue

  setup do
    :ok = UM.Catalogue.Fixtures.clear_db
    canonical = UM.Catalogue.Fixtures.canonical_piece
    {:ok, %{canonical: canonical}}
  end

  test "new item page is available", %{canonical: piece} do
    request = get({"/new", %{"piece_id" => piece.id}})
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "UD#{piece.id}")
  end

  test "successful item creation", %{canonical: piece} do
    request = post("/", %{
      "item" => %{
        "name" => "Flute part",
        "piece_id" => "#{piece.id}",
        "initial_price" => "40",
        "discounted_price" => "20",
        "asset" => %Raxx.Upload{filename: "bob.png", content: "hello world"},
    }})
    response = Controller.handle_request(request, :nostate)
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "Item+created")
    assert String.contains?(location, UM.Catalogue.Piece.catalogue_number(piece))
  end

  test "item creation with missing data", %{canonical: piece} do
    request = post("/", %{
      "item" => %{
        "name" => "Flute part",
        "piece_id" => "#{piece.id}",
        "initial_price" => "",
        "discounted_price" => "20",
        "asset" => %Raxx.Upload{filename: "bob.png", content: "hello world"},
    }})
    response = Controller.handle_request(request, :nostate)
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces")
    assert String.contains?(location, "invalid+item")
  end

  test "item edit page is available", %{canonical: piece} do
    {:ok, item} = UM.Catalogue.create_item(%{
      piece_id: piece.id,
      name: "This piece",
      asset: "somefile.mp3",
      initial_price: 40
    })
    request = get("/#{item.id}/edit")
    response = Controller.handle_request(request, :nostate)
    assert 200 == response.status
    assert String.contains?(response.body, "value=\"This piece\"")
  end

  test "can edit an item", %{canonical: piece} do
    {:ok, item} = UM.Catalogue.create_item(%{
      piece_id: piece.id,
      name: "This piece",
      asset: "somefile.mp3",
      initial_price: 40
    })
    # was previously a put
    request = put("/#{item.id}", %{"item" => %{
      "name" => "Flute part",
      "piece_id" => "#{piece.id}",
      "initial_price" => "90",
      "discounted_price" => "20",
      "asset" => %Raxx.Upload{filename: "", content: ""},
    }})
    response = Controller.handle_request(request, :nostate)
    assert 302 == response.status
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces/UD101/edit")
    assert String.contains?(location, "Item+updated")
    {:ok, updated_item} = UM.Catalogue.fetch_item(item.id)
    assert "somefile.mp3" == updated_item.asset
    assert 9000 == updated_item.initial_price
  end

  test "can delete an item", %{canonical: piece} do
    {:ok, item} = UM.Catalogue.create_item(%{
      piece_id: piece.id,
      name: "This piece",
      asset: "somefile.mp3",
      initial_price: 40
    })
    request = delete("/#{item.id}")
    response = Controller.handle_request(request, :nostate)
    assert {:ok, piece} = UM.Catalogue.load_items(%{id: piece.id})
    assert [] == piece.items
    location = Raxx.Patch.response_location(response)
    assert String.contains?(location, "/admin/pieces")
    assert String.contains?(location, "Item+removed")
  end
end
