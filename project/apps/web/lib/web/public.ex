defmodule UM.Web.Public do
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content, :session]

  footer_file = String.replace_suffix(__ENV__.file, ".ex", "/footer.html.eex")
  EEx.function_from_file :def, :footer_partial, footer_file, []

  header_file = String.replace_suffix(__ENV__.file, ".ex", "/header.html.eex")
  EEx.function_from_file :def, :header_partial, header_file, [:session]

  def handle_request(request, env) do
    session = UM.Web.Session.get(request)
    {"um-flash", flash} = List.keyfind(request.headers, "um-flash", 0, {"um-flash", %{}})

    session = UM.Web.Session.load_customer(session)
    session = Map.merge(session, flash)
    session = Map.merge(session, %{shopping_basket: %{id: "TODO"}})
    case public_endpoint(request, env) do
      request = %{body: nil} ->
        request
      request = %{body: ""} ->
        request
      request = %{status: _, body: content} ->
        %{request | body: layout_page(content, session)}
        # TODO adjust content length?
    end
  end

  defp public_endpoint(request = %{path: ["about" | rest]}, env) do
    UM.Web.About.handle_request(%{request| path: rest}, env)
  end

  defp public_endpoint(request = %{path: ["customers" | rest]}, env) do
    UM.Web.Customers.handle_request(%{request| path: rest}, env)
  end
  defp public_endpoint(request = %{path: ["sessions" | rest]}, env) do
    UM.Web.SessionsController.handle_request(%{request| path: rest}, env)
  end

  defp public_endpoint(request = %{path: ["pieces" | rest]}, env) do
    UM.Web.PiecesController.handle_request(%{request| path: rest}, env)
  end

  defp public_endpoint(request, env) do
    UM.Web.Home.handle_request(request, env)
  end

  ## HELPERS

  # FIXME Change to logged_in? / authenticated?
  defp guest_session?(session) do
    UM.Web.Session.guest_session?(session)
  end

  defp customer_account_url(session) do
    UM.Web.Session.customer_account_url(session)
  end

  defp customer_name(%{customer: %{first_name: f, last_name: l}}) do
    "#{f} #{l}"
  end

  defp preferred_currency(session) do
    UM.Web.Session.currency_preference(session)
  end

  # DEBT will be order in the future
  defp view_basket_url(%{shopping_basket: %{id: id}}) do
    case id do
      id when is_binary(id) ->
        "/shopping_baskets/#{id}"
    end
  end

  defp number_of_purchases(_session) do
    # TODO
    2
  end

  def current_basket_total(_session) do
    "£4.25"
  end

  def csrf_tag do
    "" #TODO
  end


end
