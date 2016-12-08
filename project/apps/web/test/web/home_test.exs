defmodule UM.Web.HomeTest do
  use ExUnit.Case, async: true

  import Raxx.Test

  # This is a horrible duplication
  @canonical_piece %{
    id: 101,
    title: "Canonical Piece",
    sub_heading: "The very first piece",
    description: "I uses this piece for testing all the flipping time",
    level_overview: "not that easy",
    notation_preview: %Raxx.Upload{
      content: "My Upload document"
    }}

  setup do
    Moebius.Query.db(:purchases) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    Moebius.Query.db(:items) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    Moebius.Query.db(:pieces) |> Moebius.Query.delete |> Moebius.Db.run
    # |> IO.inspect
    piece = @canonical_piece
    {:ok, %{id: _id}} = UM.Catalogue.create_piece(piece)
  end

  test "home page returns pieces" do
    request = get("/")
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 200
    assert String.contains?(response.body, "UD101")
  end

  test "redirects to the correct search for piano page" do
    request = get("/piano")
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[piano]=on" == Raxx.Patch.response_location(response)
  end

  test "redirects to the correct search for flute page" do
    request = get("/flute")
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?catalogue_search[flute]=on" == Raxx.Patch.response_location(response)
  end

  test "redirects to the correct search for woodwind page" do
    request = get("/woodwind")
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces?" <> _query = Raxx.Patch.response_location(response)
  end

  # FIXME check guest vs logged in
  test "sets currency preference" do
    request = post("/currency", form_data(%{"preference" => "USD"}), [{"um-user-id", "dummy-guest-id"}])
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/" == Raxx.Patch.response_location(response)
    assert {"um-set-session", %{currency_preference: "USD"}} == List.keyfind(response.headers, "um-set-session", 0)
  end

  def session(data) do
    [{"um-session", struct(Session, data)}]
  end
end
