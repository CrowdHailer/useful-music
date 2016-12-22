defmodule UM.Web.Public do
  import UM.Web.ViewHelpers
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content, :session]

  footer_file = String.replace_suffix(__ENV__.file, ".ex", "/footer.html.eex")
  EEx.function_from_file :def, :footer_partial, footer_file, []

  header_file = String.replace_suffix(__ENV__.file, ".ex", "/header.html.eex")
  EEx.function_from_file :def, :header_partial, header_file, [:session]

  def handle_request(request, env) do
    {session, request} = UM.Web.Session.from_request(request)
    {"um-flash", flash} = List.keyfind(request.headers, "um-flash", 0, {"um-flash", %{}})

    session = UM.Web.Session.load_customer(session)
    session = Map.merge(session, flash)
    case public_endpoint(request, env) do
      request = %{body: nil} ->
        request
      request = %{body: ""} ->
        request
      request = %{status: _, body: content} ->
        %{request | body: layout_page(content, session)}
    end
  end

  defp public_endpoint(request = %{path: ["about" | rest]}, env) do
    UM.Web.About.handle_request(%{request| path: rest}, env)
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

  defp public_endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.PiecesController.handle_request(%{request| path: rest}, env)
  end

  defp public_endpoint(request, env) do
    UM.Web.Home.handle_request(request, env)
  end
end
