defmodule UM.Web.Public do
  import UM.Web.ViewHelpers
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content, :session, :flash]

  footer_file = String.replace_suffix(__ENV__.file, ".ex", "/footer.html.eex")
  EEx.function_from_file :def, :footer_partial, footer_file, []

  header_file = String.replace_suffix(__ENV__.file, ".ex", "/header.html.eex")
  EEx.function_from_file :def, :header_partial, header_file, [:session]

  def handle_request(request, env) do
    session = UM.Web.fetch_session(request)
    flash = UM.Web.fetch_flash(request)

    case public_endpoint(request, env) do
      request = %{body: nil} ->
        request
      request = %{body: ""} ->
        request
      request = %{status: _, body: content} ->
        %{request | body: layout_page(content, session, flash)}
    end
  end

  defp public_endpoint(request = %{path: ["about" | rest]}, env) do
    UM.Web.AboutController.handle_request(%{request| path: rest}, env)
  end

  defp public_endpoint(request = %{path: ["customers" | rest]}, env) do
    UM.Web.CustomersControllerController.handle_request(%{request| path: rest}, env)
  end
  defp public_endpoint(request = %{path: ["sessions" | rest]}, env) do
    UM.Web.SessionsController.handle_request(%{request| path: rest}, env)
  end
  defp public_endpoint(request = %{path: ["password_resets" | rest]}, env) do
    UM.Web.PasswordResetsController.handle_request(%{request| path: rest}, env)
  end
  defp public_endpoint(request = %{path: ["orders" | rest]}, env) do
    UM.Web.OrdersController.handle_request(%{request| path: rest}, env)
  end
  defp public_endpoint(request = %{path: ["shopping_baskets" | rest]}, env) do
    UM.Web.CartsController.handle_request(%{request| path: rest}, env)
  end

  defp public_endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.PiecesController.handle_request(%{request| path: rest}, env)
  end

  defp public_endpoint(request, env) do
    UM.Web.HomeController.handle_request(request, env)
  end
end
