defmodule UM.Web.PiecesController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page, :search]

  def handle_request(%{path: [], method: :GET}, _env) do
    {:ok, pieces} = UM.Catalogue.search_pieces
    Raxx.Response.ok(index_page_content(paginate_pieces(pieces), %{}))
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

  defp stringify_option(term) do
    # category.to_s.capitalize.gsub('_', ' ')
    String.capitalize("#{term}")
  end
end
