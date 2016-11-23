defmodule UM.Web.Admin do
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
    Raxx.Response.ok("Index page")
  end

  def endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.Admin.Pieces.handle_request(%{request | path: rest}, env)
  end
end
