defmodule UM.Web.SessionsController do
  # alias UM.Web.Customers.CreateForm

  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:target]

  def handle_request(request = %{path: ["new"], query: query, method: :GET}, _) do
    {"um-session", session} = List.keyfind(request.headers, "um-session", 0)
    {"um-flash", flash} = List.keyfind(request.headers, "um-flash", 0, {"um-flash", %{}})
    case session do
      %{customer: %{id: id}} ->
        # trusted environment assume real id
        Raxx.Response.see_other("", [{"location", "/customers/#{id}"}])
      %{customer: nil} ->
        target = Map.get(query, "target", "")
        Raxx.Response.ok(UM.Web.Home.layout_page(new_page_content(target), Map.merge(%{
        shopping_basket: %{id: "TODO-basket", number_of_purchases: 2, price: 100},
        customer: %{id: "TODO-", guest?: true, working_currency: "GBP"},
        error: "Do this now TODO",
        success: nil
        }, flash)))
    end
  end

  def handle_request(request = %{path: []}, _env) do
    {:ok, form} = Raxx.Request.content(request)
    target = Map.get(form, "target")
    form = Utils.sub_form(form, "session")
    case {:ok, %{email: form["email"], password: form["password"]}} do
      {:ok, data} ->
        case UM.Accounts.authenticate(data) do
          {:ok, customer} ->
            response = Raxx.Response.see_other("", [
              {"location", target || "/customers/#{customer.id}"},
              {"um-set-session", %{customer: %{id: customer.id}}},
              {"um-flash", %{success: "Welcome back #{customer.first_name} #{customer.last_name}"}}
            ])
          {:error, :invalid_credentials} ->
            Raxx.Response.see_other("", [
              {"location", "/sessions/new"},
              {"um-flash", %{error: "Invalid login details"}}
            ])
        end
    end
  end

  def handle_request(_request = %{path: ["logout"]}, _) do
    response = Raxx.Response.see_other("", [{"location", "/"}])
    Raxx.Session.Open.overwrite(nil, response)
  end

  defp csrf_tag do
    "TODO"
  end
end
