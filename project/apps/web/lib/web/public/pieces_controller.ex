defmodule UM.Web.PiecesController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page, :search]

  def handle_request(%{path: [], method: :GET, query: query}, _env) do
    search = Map.get(query, "catalogue_search", %{})

    {:ok, tags} = WebForm.validate(Enum.into(Enum.map(
      (instruments ++ levels ++ categories),
      (fn(option) -> {option, {:boolean, false}} end)
    ), %{}), search)

    page = %{
      page_number: Map.get(search, "page", "1") |> :erlang.binary_to_integer,
      page_size: Map.get(search, "page_size", "12") |> :erlang.binary_to_integer
    }

    # in the future this should paginate the query
    {:ok, pieces} = UM.Catalogue.search_pieces(tags)
    Raxx.Response.ok(index_page_content(Page.paginate(pieces, page), tags))
  end

  defp instruments do
    # Maybe belongs at Catalogue layer
    UM.Catalogue.Piece.all_instruments
  end

  defp levels do
    [:beginner,
    :intermediate,
    :advanced,
    :professional]
  end

  defp categories do
    [:solo,
    :solo_with_accompaniment,
    :duet,
    :trio,
    :quartet,
    :larger_ensembles]
  end

  defp stringify_option(term) do
    "#{term}"
    |> String.capitalize
    |> String.replace("_", " ")
  end
end
