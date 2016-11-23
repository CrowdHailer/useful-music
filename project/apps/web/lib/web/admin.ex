defmodule UM.Web.Admin do
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content]

  @identifier_header "um-user-id"

  def handle_request(request, env) do
    user_id = Raxx.Patch.get_header(request, @identifier_header)
    case user_id do
      "dummy-admin-id" ->
        endpoint(request, env)
      "dummy-customer-id" ->
        Raxx.Response.forbidden
    end
  end

  def endpoint(%{path: []}, _env) do
    Raxx.Response.ok(layout_page("Index page"))
  end

  def endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.Admin.Pieces.handle_request(%{request | path: rest}, env)
  end
end
