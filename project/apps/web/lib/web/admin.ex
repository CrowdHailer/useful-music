defmodule UM.Web.Admin do
  @identifier_header "um-user-id"

  def handle_request(request, env) do
    user_id = Raxx.Patch.get_header(request, @identifier_header)
    case user_id do
      "admin" ->
        Raxx.Response.ok
      "customer" ->
        Raxx.Response.forbidden
    end
  end
end
