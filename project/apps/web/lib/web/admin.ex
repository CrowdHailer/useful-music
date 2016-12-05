defmodule UM.Web.Admin do
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content, :flash]

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, []

  def handle_request(request, env) do
    {"um-session", session} = List.keyfind(request.headers, "um-session", 0)
    {"um-flash", flash} = List.keyfind(request.headers, "um-flash", 0, {"um-flash", %{}})

    customer = case Map.get(session, :customer) do
      %{id: id} ->
        user = UM.Accounts.fetch_customer(id)
      nil ->
        %{id: nil, admin: false}
    end

    case customer do
      %{admin: true} ->
        case endpoint(request, env) do
          request = %{body: nil} ->
            request
          request = %{body: ""} ->
            request
          request = %{status: _, body: content} ->
            %{request | body: layout_page(content, flash)}
            # TODO adjust content length?
        end
      %{admin: false} ->
        Raxx.Response.forbidden
    end
  end

  def endpoint(%{path: []}, _env) do
    Raxx.Response.ok(index_page_content)
  end

  def endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.Admin.Pieces.handle_request(%{request | path: rest}, env)
  end

  def endpoint(request = %{path: ["customers" | rest]}, env) do
    UM.Web.Admin.Customers.handle_request(%{request | path: rest}, env)
  end
end
