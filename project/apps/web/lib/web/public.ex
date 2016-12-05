defmodule UM.Web.Public do
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content, :session]

  footer_file = String.replace_suffix(__ENV__.file, ".ex", "/footer.html.eex")
  EEx.function_from_file :def, :footer_partial, footer_file, []

  header_file = String.replace_suffix(__ENV__.file, ".ex", "/header.html.eex")
  EEx.function_from_file :def, :header_partial, header_file, [:session]

  def handle_request(request, env) do
    {"um-session", session} = List.keyfind(request.headers, "um-session", 0)
    {"um-flash", flash} = List.keyfind(request.headers, "um-flash", 0, {"um-flash", %{}})

    customer = case Map.get(session, :customer) do
      %{id: id} ->
        user = UM.Accounts.fetch_customer(id)
        Map.merge(user, %{currency_preference: "GBP"})
      nil ->
        %{id: nil, currency_preference: "GBP", name: ""}
    end
    session = Map.merge(%{}, flash)
    session = Map.merge(session, %{customer: customer, shopping_basket: %{id: "TODO"}})
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

  defp public_endpoint(request, env) do
    UM.Web.Home.handle_request(request, env)
  end

  ## HELPERS

  # FIXME Change to logged_in? / authenticated?
  defp guest_session?(%{customer: %{id: id}}) do
    case id do
      nil ->
        true
      id when is_binary(id) ->
        false
    end
  end

  defp customer_account_url(%{customer: %{id: id}}) do
    case id do
      nil ->
        "#" # FIXME some sensible default but never comes up
      id when is_binary(id) ->
        "/customers/#{id}"
    end
  end

  defp customer_name(%{customer: %{first_name: f, last_name: l}}) do
    "#{f} #{l}"
  end

  defp preferred_currency(%{customer: %{currency_preference: preference}}) do
    preference || "GBP"
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
