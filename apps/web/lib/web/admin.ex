defmodule UM.Web.Admin do
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content, :flash]

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, []

  def handle_request(request, env) do
    session = UM.Web.fetch_session(request)
    flash = UM.Web.fetch_flash(request)

    case UM.Web.Session.admin?(session) do
      true ->
        case endpoint(request, env) do
          request = %{body: nil} ->
            request
          request = %{body: ""} ->
            request
          request = %{status: _, body: content} ->
            %{request | body: layout_page(content, flash)}
        end
      false ->
        Raxx.Response.forbidden("Forbidden")
    end
  end

  def endpoint(%{path: []}, _env) do
    Raxx.Response.ok(index_page_content)
  end

  def endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.Admin.PiecesController.handle_request(%{request | path: rest}, env)
  end
  def endpoint(request = %{path: ["items" | rest]}, env) do
    UM.Web.Admin.ItemsController.handle_request(%{request | path: rest}, env)
  end
  def endpoint(request = %{path: ["discounts" | rest]}, env) do
    UM.Web.Admin.DiscountsController.handle_request(%{request | path: rest}, env)
  end

  def endpoint(request = %{path: ["customers" | rest]}, env) do
    UM.Web.Admin.CustomersController.handle_request(%{request | path: rest}, env)
  end
end
