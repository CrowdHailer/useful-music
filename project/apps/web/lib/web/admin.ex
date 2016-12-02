defmodule UM.Web.Admin do
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content]

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, []

  def handle_request(request, env) do
    case get_session(request) do
      %{customer: %{id: id}} ->
        %{admin: admin} = UM.Accounts.fetch_customer(id)
        case admin do
          true ->
            endpoint(request, env)
          false ->
            Raxx.Response.forbidden
        end
      nil ->
        Raxx.Response.forbidden
    end
  end

  def endpoint(%{path: []}, _env) do
    Raxx.Response.ok(layout_page(index_page_content))
  end

  def endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.Admin.Pieces.handle_request(%{request | path: rest}, env)
  end

  def endpoint(request = %{path: ["customers" | rest]}, env) do
    UM.Web.Admin.Customers.handle_request(%{request | path: rest}, env)
  end

  def get_session(request) do
    {"um-session", session} = List.keyfind(request.headers, "um-session", 0)
    session
  end
end
