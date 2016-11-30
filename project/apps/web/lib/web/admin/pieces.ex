defmodule UM.Web.Admin.Pieces do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, []

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

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

  defp csrf_tag do
    "TODO create a real tag"
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
