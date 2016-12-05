defmodule UM.Web.Public do
  require EEx
  layout_file = String.replace_suffix(__ENV__.file, ".ex", "/layout.html.eex")
  EEx.function_from_file :def, :layout_page, layout_file, [:content, :session]

  footer_file = String.replace_suffix(__ENV__.file, ".ex", "/footer.html.eex")
  EEx.function_from_file :def, :footer_partial, footer_file, []

  header_file = String.replace_suffix(__ENV__.file, ".ex", "/header.html.eex")
  EEx.function_from_file :def, :header_partial, header_file, [:shopping_basket, :session]

  @session %{
    shopping_basket: %{id: "TODO-basket", number_of_purchases: 2, price: 100},
    customer: %{id: "TODO-", guest?: true, working_currency: "GBP"},
    error: nil,
    success: nil
  }

  def handle_request(request, env) do
    {"um-session", session} = List.keyfind(request.headers, "um-session", 0)
    {"um-flash", flash} = List.keyfind(request.headers, "um-flash", 0, {"um-flash", %{}})
    IO.inspect(session)

    customer = case Map.get(session, :customer) do
      %{id: id} ->
        user = UM.Accounts.fetch_customer(id)
        Map.merge(user, %{currency_preference: "GBP"})
      nil ->
        %{id: nil, currency_preference: "GBP", name: ""}
    end
    |> IO.inspect
    session = Map.merge(@session, flash)
    session = Map.merge(session, %{customer: customer})
    case public_endpoint(request, env) do
      r = %{status: _, body: content} ->
        %{r | body: layout_page(content, session)}
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

  def csrf_tag do
    "" #TODO
  end

  def local_price(_) do
    %{format: "TODO"}
  end

  def customer_name(%{customer: %{first_name: f, last_name: l}}) do
    "#{f} #{l}"
  end

  def preferred_currency(session = %{customer: %{currency_preference: preference}}) do
    preference || "GBP"
  end
end
