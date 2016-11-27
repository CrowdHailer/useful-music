defmodule UM.Web.Admin.Pieces do
  require EEx

  @piece_types %{
    id: :integer,
    title: :string,
    sub_heading: :string,
    level_overview: :string,
    description: :string,
    solo: :boolean,
    solo_with_accompaniment: :boolean,
    duet: :boolean,
    trio: :boolean,
    quartet: :boolean,
    larger_ensembles: :boolean,
    collection: :boolean,
    beginner: :boolean,
    intermediate: :boolean,
    advanced: :boolean,
    professional: :boolean,
    piano: :boolean,
    recorder: :boolean,
    flute: :boolean,
    oboe: :boolean,
    clarineo: :boolean,
    clarinet: :boolean,
    bassoon: :boolean,
    saxophone: :boolean,
    trumpet: :boolean,
    violin: :boolean,
    viola: :boolean,
    percussion: :boolean,
    notation_preview: "", # Hash
    audio_preview: "", # Hash
    cover_image: "", # Hash
    print_link: "", # String
    print_title: "", # String
    weezic_link: "", # String
    meta_description: "", # String
    meta_keywords: "", # String
  }

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, []

  def handle_request(%{path: [], method: :GET}, _env) do
    Raxx.Response.ok("All pieces TODO show UM100")
  end

  def handle_request(request = %{path: [], method: :POST}, _env) do
    {:ok, form} = Raxx.Request.content(request)
    piece = Enum.map(@piece_types, fn
      ({key, :boolean}) ->
        case Map.get(form, "piece[#{key}]", "") do
          "on" -> {key, true}
          "" -> {key, false}
        end
      ({key, :integer}) ->
        case Map.get(form, "piece[#{key}]", "") |> Integer.parse do
          {i, ""} -> {key, i}
          _ -> {key, nil}
        end
      ({key, v}) ->
        {key, v}
    end)
    |> Enum.into(%{})
    case UM.Catalogue.create_piece(piece) do
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

  defp csrf_tag do
    "TODO create a real tag"
  end
end
