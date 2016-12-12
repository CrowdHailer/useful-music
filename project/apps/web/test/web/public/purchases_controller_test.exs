defmodule UM.Web.PurchasesControllerTest do
  use ExUnit.Case
  import Raxx.Test

  alias UM.Catalogue
  alias UM.Web.PurchasesController, as: Controller

  setup do
    Moebius.Query.db(:purchases) |> Moebius.Query.delete |> Moebius.Db.run
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run

    {:ok, _item} = Catalogue.load_fixtures
    {:ok, %{piece: %{id: 101}}}
  end

  @tag :skip
  test "can create a new purchase", %{piece: %{id: piece_id}} do
    IO.inspect(piece_id)
    {:ok, %{items: [%{id: item_id}]}} =UM.Catalogue.load_items(%{id: piece_id})
    # DEBT nest under /shopping_baskets/id
    request = post("/", form_data(%{
      "purchases" => %{
        "shopping_basket" => "",
        "items" => %{
          item_id => "4"
        }
      }
    }))
    response = Controller.handle_request(request, [])
    IO.inspect(response)

    %{"item_1" => "0", "item_2" => "4"}
    |> Enum.flat_map(fn
      ({item_id, count}) ->
        {count, ""} = Integer.parse(count)
        case count do
          0 -> []
          count -> [{item_id, count}]
        end
    end)
    |> IO.inspect
  end
end
