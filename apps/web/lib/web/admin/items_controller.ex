defmodule UM.Web.Admin.ItemsController do
  import UM.Web.ViewHelpers
  require EEx

  form_template = String.replace_suffix(__ENV__.file, ".ex", "/item_form.html.eex")
  EEx.function_from_file :def, :edit_form, form_template, [:item, :piece]


  def handle_request(%{method: :GET, path: ["new"], query: %{"piece_id" => piece_id}}, _) do
    {piece_id, ""} = Integer.parse(piece_id)
    case UM.Catalogue.fetch_piece(piece_id) do
      {:ok, piece} ->
        item = %UM.Catalogue.Item{}
        Raxx.Response.ok(edit_form(item, piece))
    end
  end

  def handle_request(%{method: :POST, path: [], body: %{"item" => form}}, _) do
    form_or_errors = UM.Web.Admin.ItemsController.ItemForm.validate(form)
    case form_or_errors do
      {:ok, data} ->
        case UM.Catalogue.create_item(data) do
          {:ok, item} ->
            Raxx.Patch.redirect("/admin/pieces/UD#{item.piece_id}/edit", %{success: "Item created"})
          {:error, exception} ->
            Bugsnag.report(exception)
            IO.inspect(exception)
            Raxx.Patch.redirect("/admin/pieces/UD#{data.piece_id}/edit")
            |> UM.Web.with_flash(error: exception)
        end
      {:error, error} ->
        # DEBT send error to bugsnag or similar
        IO.inspect(error)
        error_message = "Could not create invalid item"
        Raxx.Patch.redirect("/admin/pieces", %{error: error_message})
    end
  end

  def handle_request(%{method: :GET, path: [id, "edit"]}, _) do
    case UM.Catalogue.fetch_item(id) do
      {:ok, item} ->
        {:ok, piece} = UM.Catalogue.fetch_piece(item.piece_id)
        Raxx.Response.ok(edit_form(item, piece))
      # DEBT if manage to visit no item page
    end
  end

  def handle_request(%{method: :PUT, path: [id], body: %{"item" => form}}, _) do
    form_or_errors = UM.Web.Admin.ItemsController.ItemForm.validate(form)
    case form_or_errors do
      {:ok, data} ->
        data = case Map.pop(data, :asset) do
          {nil, data} ->
            data
          {something, data} ->
            Map.merge(data, %{asset: something})
        end
        {:ok, original} = UM.Catalogue.fetch_item(id)
        case UM.Catalogue.update_item(Map.merge(original, data)) do
          {:ok, item} ->
            Raxx.Patch.redirect("/admin/pieces/UD#{item.piece_id}/edit", %{success: "Item updated"})
          {:error, exception} ->
            Bugsnag.report(exception)
            IO.inspect(exception)
            Raxx.Patch.redirect("/admin/items/#{id}/edit")
            |> UM.Web.with_flash(error: exception)
        end
    end
  end

  def handle_request(%{method: :DELETE, path: [id]}, _) do
    case UM.Catalogue.delete_item(id) do
      {:ok, _id} ->
        Raxx.Patch.redirect("/admin/pieces", %{success: "Item removed"})
    end
  end
end
