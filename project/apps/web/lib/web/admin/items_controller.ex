defmodule UM.Web.Admin.ItemsController do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:piece]

  def handle_request(%{method: :GET, path: ["new"], query: %{"piece_id" => piece_id}}, _) do
    {piece_id, ""} = Integer.parse(piece_id)
    case UM.Catalogue.fetch_piece(piece_id) do
      {:ok, piece} ->
        Raxx.Response.ok(new_page_content(piece))
    end
  end

  defp catalogue_number(piece) do
    UM.Catalogue.Piece.catalogue_number(piece)
  end

  defp product_name(piece) do
    UM.Catalogue.Piece.product_name(piece)
  end

  defp csrf_tag do
    "" # TODO
  end
end
