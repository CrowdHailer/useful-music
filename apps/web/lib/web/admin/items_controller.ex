defmodule UM.Web.Admin.ItemsController do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:piece]

  edit_file = String.replace_suffix(__ENV__.file, ".ex", "/edit.html.eex")
  EEx.function_from_file :def, :edit_page_content, edit_file, [:item, :piece]

  def handle_request(%{method: :GET, path: ["new"], query: %{"piece_id" => piece_id}}, _) do
    {piece_id, ""} = Integer.parse(piece_id)
    case UM.Catalogue.fetch_piece(piece_id) do
      {:ok, piece} ->
        Raxx.Response.ok(new_page_content(piece))
    end
  end

  def handle_request(%{method: :POST, path: [], body: %{"item" => form}}, _) do
    form_or_errors = UM.Web.Admin.ItemsController.ItemForm.validate(form)
    case form_or_errors do
      {:ok, data} ->
        case UM.Catalogue.create_item(data) do
          {:ok, item} ->
            Raxx.Patch.redirect("/admin/pieces/UD#{item.piece_id}/edit", %{success: "Item created"})
        end
      {:error, _error} ->
        # DEBT send error to bugsnag or similar
        error_message = "Could not create invalid item"
        Raxx.Patch.redirect("/admin/pieces", %{error: error_message})

    end
  end

  def handle_request(%{method: :GET, path: [id, "edit"]}, _) do
    case UM.Catalogue.fetch_item(id) do
      {:ok, item} ->
        {:ok, piece} = UM.Catalogue.fetch_piece(item.piece_id)
        Raxx.Response.ok(edit_page_content(item, piece))
      # DEBT if manage to visit no item page
    end
  end

  def handle_request(%{method: :POST, path: [id], body: %{"item" => form}}, _) do
    form_or_errors = UM.Web.Admin.ItemsController.ItemForm.validate(form)
    case form_or_errors do
      {:ok, data} ->
        case UM.Catalogue.update_item(Map.merge(%{id: id}, data)) do
          {:ok, item} ->
            Raxx.Patch.redirect("/admin/pieces/UD#{item.piece_id}/edit", %{success: "Item created"})
          # DEBT if manage to visit no item page
        end
    end
  end

  def handle_request(%{method: :DELETE, path: [id]}, _) do
    case UM.Catalogue.delete_item(id) do
      {:ok, id} ->
        Raxx.Patch.redirect("/admin/pieces", %{success: "Item removed"})
    end
  end

  defp catalogue_number(piece) do
    UM.Catalogue.Piece.catalogue_number(piece)
  end

  defp product_name(piece) do
    UM.Catalogue.Piece.product_name(piece)
  end

  defp asset_url(_item) do
    "TODO"
  end
end
