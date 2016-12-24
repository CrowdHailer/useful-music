defmodule UM.Web.SessionsController do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:target]

  def handle_request(request = %{path: ["new"], query: query, method: :GET}, _) do
    case UM.Web.fetch_session(request) do
      %UM.Web.Session.UnAuthenticated{} ->
        target = Map.get(query, "target", "")
        Raxx.Response.ok(new_page_content(target))
      %UM.Web.Session.Authenticated{account: %{id: id}} ->
        Raxx.Patch.redirect("/customers/#{id}")
    end
  end

  def handle_request(request = %{path: [], method: :POST, body: body}, _env) do
    session = UM.Web.fetch_session(request)
    form = Map.get(body, "session")
    case {:ok, %{email: form["email"], password: form["password"]}} do
      {:ok, data} ->
        case UM.Accounts.authenticate(data) do
          {:ok, customer} ->
            target = Map.get(body, "target", "/customers/#{customer.id}")
            Raxx.Patch.redirect(target)
            |> UM.Web.with_flash(success: "Welcome back #{UM.Accounts.Customer.name(customer)}")
            |> UM.Web.with_session(UM.Web.Session.login(session, customer))
          {:error, :invalid_credentials} ->
            Raxx.Patch.redirect("/sessions/new")
            |> UM.Web.with_flash(error: "Invalid login details")
        end
    end
  end

  def handle_request(%{path: [], method: :DELETE}, _) do
    Raxx.Patch.redirect("/")
    |> UM.Web.with_session(UM.Web.Session.new)
  end
end
