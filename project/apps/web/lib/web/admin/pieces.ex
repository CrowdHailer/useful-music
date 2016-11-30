defmodule UM.Web.Admin.Pieces do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, []

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:page]

  def handle_request(%{path: [], method: :GET}, _env) do
    Raxx.Response.ok(UM.Web.Admin.layout_page(index_page_content(%{
      previous: 0,
      next: 0,
      last: 0,
      size: 10,
      pieces: [{%{
        id: 100,
        title: "some stuff",
        sub_heading: "boo",
        description: "lorem lorem lorem"
        }, 1}]
      })))
  end

  def handle_request(%{path: ["search"], method: :GET, query: query}, _env) do
    search = Map.get(query, "search")
    id = case search do
      "UD" <> id ->
        id
      id -> id
    end
    Raxx.Response.found("", [{"location", "/admin/pieces/UD#{id}/edit"}])
  end

  def handle_request(%{path: ["new"]}, _env) do
    Raxx.Response.ok(UM.Web.Admin.layout_page(new_page_content))
  end

  def handle_request(request = %{path: [], method: :POST}, _env) do
    {:ok, form} = Raxx.Request.content(request)
    form = Enum.map(form, fn
      ({key, value}) ->
        %{"attr" => attribute} =Regex.named_captures(~r/piece\[(?<attr>[^\]]*)\]/, key)
        {attribute, value}
    end)
    |> Enum.into(%{})
    IO.inspect(form)
    case __MODULE__.CreateForm.validate(form) do
      {:ok, data} ->
        IO.inspect(data)
        case UM.Catalogue.create_piece(data) do
          {:ok, piece} ->
            Raxx.Response.found("", [{"location", "/admin/pieces"}])
          {:error, :invalid_piece} ->
            # loose all data but thats just ok on the admin side, at the moment
            Raxx.Response.found("", [{"location", "/admin/pieces/new"}])
          {:error, :id_already_used} ->
            # TODO change to sending to the edit page
            Raxx.Response.found("", [{"location", "/admin/pieces/new"}])
        end
    end
  end


  defp csrf_tag do
    "TODO create a real tag"
  end
end
