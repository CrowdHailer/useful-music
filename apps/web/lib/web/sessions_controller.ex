defmodule UM.Web.SessionsController do
  # alias UM.Web.Customers.CreateForm

  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:target]

  def handle_request(request = %{path: ["new"], query: query, method: :GET}, _) do
    {session, request} = UM.Web.Session.from_request(request)
    case UM.Web.Session.current_customer(session) do
      :guest ->
        target = Map.get(query, "target", "")
        Raxx.Response.ok(new_page_content(target))
      %{id: id} ->
        Raxx.Patch.redirect("/customers/#{id}")
    end
  end

  def handle_request(%{path: [], method: :POST, body: form}, _env) do
    target = Map.get(form, "target")
    form = Map.get(form, "session")
    case {:ok, %{email: form["email"], password: form["password"]}} do
      {:ok, data} ->
        case UM.Accounts.authenticate(data) do
          {:ok, customer} ->
            # Also use the login function from the sessions module
            response = Raxx.Response.see_other("", [
              {"location", target || "/customers/#{customer.id}"},
              {"um-set-session", %UM.Web.Session{customer_id: customer.id, currency_preference: customer.currency_preference}},
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

  def handle_request(_request = %{path: [], method: :DELETE}, _) do
    response = Raxx.Response.see_other("", [{"location", "/"}])
    Raxx.Session.Open.overwrite(nil, response)
  end
end
