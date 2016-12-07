defmodule UM.Web.PiecesController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page, :search]

  def handle_request(%{path: [], method: :GET, query: query}, _env) do
    search = Map.get(query, "catalogue_search", %{})
    # This should always produce a search
    {:ok, tags} = WebForm.validate(Enum.into(Enum.map(
      (instruments ++ levels ++ categories),
      (fn(option) -> {option, {:boolean, false}} end)
    ), %{}), search)
    {:ok, pieces} = UM.Catalogue.search_pieces(tags)
    Raxx.Response.ok(index_page_content(paginate_pieces(pieces), tags))
  end

  defp paginate_pieces(array) do
    %{
      previous: 0,
      next: 0,
      last: 0,
      current: 0,
      size: 10,
      pieces: Enum.zip(Enum.take(array, 10), 1..10)
      }
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
