defmodule UM.Web.PiecesController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page, :search]

  show_file = String.replace_suffix(__ENV__.file, ".ex", "/show.html.eex")
  EEx.function_from_file :def, :show_page_content, show_file, [:piece, :search, :session]

  def handle_request(%{path: [], method: :GET, query: query}, _env) do
    search = Map.get(query, "catalogue_search", %{})

    {:ok, tags} = WebForm.validate(Enum.into(Enum.map(
      (instruments ++ levels ++ categories),
      (fn(option) -> {option, WebForm.checkbox()} end)
    ), %{}), search)

    page = %{
      page_number: Map.get(search, "page", "1") |> :erlang.binary_to_integer,
      page_size: Map.get(search, "page_size", "12") |> :erlang.binary_to_integer
    }

    # in the future this should paginate the query
    {:ok, pieces} = UM.Catalogue.search_pieces(tags)
    Raxx.Response.ok(index_page_content(Page.paginate(pieces, page), tags))
  end

  def handle_request(%{path: ["search"], method: :GET, query: %{"search" => search}}, _) do
    case search do
      "UD" <> id ->
        Raxx.Patch.redirect("/pieces/UD#{id}")
      search ->
        {:ok, pieces} = UM.Catalogue.search_title(search)

        page = %{
          page_size: 24,
          page_number: 1
        }
        Raxx.Response.ok(index_page_content(Page.paginate(pieces, page), %{}))
    end
  end

  def handle_request(request = %{path: ["UD" <> id], method: :GET}, _) do
    {session, request} = UM.Web.Session.from_request(request)
    {id, ""} = Integer.parse(id)
    case UM.Catalogue.fetch_piece(id) do
      {:ok, piece} ->
        {:ok, piece} = UM.Catalogue.load_items(piece)
        Raxx.Response.ok(show_page_content(piece, %{}, session))
      {:error, :piece_not_found} ->
        Raxx.Patch.redirect("/pieces", %{flash: "Piece not found"})
    end
  end

  defp instruments do
    # Maybe belongs at Catalogue layer
    UM.Catalogue.Piece.all_instruments
  end

  defp levels do
    UM.Catalogue.Piece.all_levels
  end

  defp categories do
    UM.Catalogue.Piece.all_categories
  end

  defp shopping_basket do
    %{
      id: "TODO"
    }
  end
  defp local_price(price) do
    "£TODO"
  end

  defp stringify_option(term) do
    "#{term}"
    |> String.capitalize
    |> String.replace("_", " ")
  end
end
