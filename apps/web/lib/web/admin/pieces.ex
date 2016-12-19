defmodule UM.Web.Admin.Pieces do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, []

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  edit_file = String.replace_suffix(__ENV__.file, ".ex", "/edit.html.eex")
  EEx.function_from_file :def, :edit_page_content, edit_file, [:piece]

  def handle_request(%{path: [], method: :GET}, _env) do
    {:ok, pieces} = UM.Catalogue.search_pieces
    # TODO fix pages
    Raxx.Response.ok(index_page_content(Page.paginate(pieces, %{page_size: 10, page_number: 1})))
  end

  def handle_request(%{path: ["search"], method: :GET, query: query}, _env) do
    id = case Map.get(query, "search") do
      "UD" <> id -> id
      id -> id
    end
    Raxx.Response.found("", [{"location", "/admin/pieces/UD#{id}/edit"}])
  end

  def handle_request(%{path: ["new"]}, _env) do
    Raxx.Response.ok(new_page_content)
  end

  def handle_request(%{path: [], method: :POST, body: %{"piece" => form}}, _env) do
    # IO.inspect(form)
    case __MODULE__.CreateForm.validate(form) do
      {:ok, data} ->
        case UM.Catalogue.create_piece(data) do
          {:ok, _piece} ->
            Raxx.Patch.redirect("/admin/pieces", %{success: "Piece created"})
          {:error, :id_already_used} ->
            # TODO change to sending to the edit page
            error_message = "Piece UD#{data.id} already exists and may be edited"
            Raxx.Patch.redirect("/admin/pieces/UD#{data.id}/edit", %{error: error_message})
          {:error, reason} ->
            Raxx.Patch.redirect("/admin/pieces/new", %{error: reason})
        end
      {:error, _reason} ->
        error_message = "Could not create invalid piece"
        Raxx.Patch.redirect("/admin/pieces/new", %{error: error_message})
    end
  end

  def handle_request(_request = %{path: ["UD" <> id, "edit"], method: :GET}, _) do
    {id, ""} = Integer.parse(id)
    case UM.Catalogue.fetch_piece(id) do
      {:ok, piece} ->
        {:ok, piece} = UM.Catalogue.load_items(piece)
        Raxx.Response.ok(edit_page_content(piece))
      {:error, :piece_not_found} ->
        Raxx.Response.not_found("Could not find piece UD#{id}")
    end
  end

  def handle_request(%{path: ["UD" <> id], method: :PUT, body: %{"piece" => form}}, _) do
    # DEBT need to merge in id before validating
    form = Map.merge(form, %{"id" => id})
    case __MODULE__.CreateForm.validate(form) do
      {:ok, data} ->
        case UM.Catalogue.update_piece(data) do
          {:ok, _piece} ->
            Raxx.Patch.redirect("/admin/pieces/UD#{data.id}/edit", %{success: "Piece updated"})
          {:error, reason} ->
            Raxx.Patch.redirect("/admin/pieces/UD#{data.id}/edit", %{error: reason})
        end
      {:error, reason} ->
        if Mix.env == :dev do
          IO.inspect(reason)
        end
        error_message = "Could not update piece"
        Raxx.Patch.redirect("/admin/pieces/new", %{error: error_message})
    end
  end

  def handle_request(%{path: ["UD" <> id], method: :DELETE}, _) do
    {id, ""} = Integer.parse(id)
    case UM.Catalogue.delete_piece(id) do
      {:ok, id} ->
        Raxx.Patch.redirect("/admin/pieces", %{success: "Piece deleted"})
    end
  end

  defp csrf_tag do
    "TODO create a real tag"
  end

  defp url(_file) do
    "TODO"
  end

end
