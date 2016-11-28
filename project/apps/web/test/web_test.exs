defmodule UM.WebTest do
  use ExUnit.Case
  doctest UM.Web

  import Raxx.Test

  test "The sites stylesheets are served" do
    request = get("/stylesheets/admin.css")
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "about controller is mounted" do
    request = get("/about")
    response = UM.Web.handle_request(request, :no_state)
    assert response.status == 200
  end

  test "login will add user id to session" do
    request = post("/login", form_data(%{email: "bill@usa.com"}))
    response = UM.Web.handle_request(request, :no_state)
    # TODO assert
  end

  import Moebius.Query
  test "database access" do
    IO.inspect("hello")
    {:ok, pid} = Moebius.Db.start_link(Moebius.get_connection)

    q = db(:pieces) |> insert(id: 100, title: "first song", sub_heading: "more details", description: "billy gene", notation_preview: "2", level_overview: "123")
    Moebius.Db.run(q)
    |> IO.inspect

    q = Moebius.Query.db(:pieces)
    Moebius.Db.run(q)
    |> IO.inspect
  end
end
