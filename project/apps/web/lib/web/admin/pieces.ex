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
    Raxx.Response.ok(UM.Web.Admin.layout_page(index_page_content(paginate_pieces(pieces))))
  end

  def handle_request(%{path: ["search"], method: :GET, query: query}, _env) do
    id = case Map.get(query, "search") do
      "UD" <> id -> id
      id -> id
    end
    Raxx.Response.found("", [{"location", "/admin/pieces/UD#{id}/edit"}])
  end

  def handle_request(%{path: ["new"]}, _env) do
    Raxx.Response.ok(UM.Web.Admin.layout_page(new_page_content))
  end

  def handle_request(request = %{path: [], method: :POST}, _env) do
    {:ok, form} = Raxx.Request.content(request)
    form = Utils.sub_form(form, "piece")
    case __MODULE__.CreateForm.validate(form) do
      {:ok, data} ->
        case UM.Catalogue.create_piece(data) do
          {:ok, _piece} ->
            Raxx.Response.found("", [{"location", "/admin/pieces"}])
          {:error, :invalid_piece} ->
            # loose all data but thats just ok on the admin side, at the moment
            Raxx.Response.found("", [{"location", "/admin/pieces/new"}])
          {:error, :id_already_used} ->
            # TODO change to sending to the edit page
            Raxx.Response.found("", [{"location", "/admin/pieces/UD#{data.id}/edit"}])
        end
      {:error, _stuff} ->
        Raxx.Response.found("", [{"location", "/admin/pieces/new"}])
    end
  end

  def handle_request(_request = %{path: ["UD" <> id, "edit"], method: :GET}, _) do
    {id, ""} = Integer.parse(id)
    case UM.Catalogue.fetch_piece(id) do
      {:ok, piece} ->
        {:ok, piece} = UM.Catalogue.load_items(piece)
        Raxx.Response.ok(UM.Web.Admin.layout_page(edit_page_content(piece)))
      {:error, :piece_not_found} ->
        Raxx.Response.not_found("Could not find piece UD#{id}")
    end
  end

  def handle_request(request = %{path: ["UD" <> id], method: :POST}, _) do
    {:ok, form} = Raxx.Request.content(request)
    form = Utils.sub_form(form, "piece")
    {id, ""} = Integer.parse(id)
    case __MODULE__.CreateForm.validate(form) do
      {:ok, data} ->
        data = %{data | id: id}
        case UM.Catalogue.update_piece(data) do
          {:ok, _piece} ->
            Raxx.Response.found("", [{"location", "/admin/pieces/UD#{data.id}/edit"}])
          {:error, :invalid_piece} ->
            # loose all data but thats just ok on the admin side, at the moment
            Raxx.Response.found("", [{"location", "/admin/pieces/UD#{data.id}/edit"}])
        end
      {:error, _stuff} ->
        Raxx.Response.found("", [{"location", "/admin/pieces/new"}])
    end
  end

  defp csrf_tag do
    "TODO create a real tag"
  end

  defp url(_file) do
    "TODO"
  end

  # TODO fix this
  defp paginate_pieces(array) do
    %{
      previous: 0,
      next: 0,
      last: 0,
      size: 10,
      pieces: Enum.zip(Enum.take(array, 10), 1..10)
      }
  end
end
