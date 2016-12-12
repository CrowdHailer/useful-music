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
    :ok = UM.Web.Fixtures.clear_db
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

  test "sets currency preference for a customer" do
    jo = UM.Web.Fixtures.jo_brand
    request = post("/currency", form_data(%{"preference" => "USD"}), UM.Web.Session.customer_session(jo))
    response = UM.Web.Home.handle_request(request, %{})
    assert "USD" == UM.Accounts.fetch_customer(jo.id).currency_preference
    assert response.status == 302
    assert "/" == Raxx.Patch.response_location(response)
    assert %{currency_preference: "USD", customer_id: id} = Raxx.Patch.response_session(response)
    assert jo.id == id
  end

  test "sets currency preference for a guest" do
    request = post("/currency", form_data(%{"preference" => "USD"}), UM.Web.Session.guest_session)
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/" == Raxx.Patch.response_location(response)
    assert %{currency_preference: "USD", customer_id: nil} = Raxx.Patch.response_session(response)
  end

  test "redirects to referrer" do
    request = post("/currency", form_data(%{"preference" => "USD"}), UM.Web.Session.guest_session ++ [{"referer", "/pieces"}])
    response = UM.Web.Home.handle_request(request, %{})
    assert response.status == 302
    assert "/pieces" == Raxx.Patch.response_location(response)
    assert %{currency_preference: "USD", customer_id: nil} = Raxx.Patch.response_session(response)
  end
end
