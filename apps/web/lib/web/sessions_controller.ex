defmodule UM.Web.SessionsController do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:target]

  def handle_request(request = %{path: ["new"], query: query, method: :GET}, _) do
    {session, _request} = UM.Web.Session.from_request(request)
    case UM.Web.Session.current_customer(session) do
      :guest ->
        target = Map.get(query, "target", "")
        Raxx.Response.ok(new_page_content(target))
      %{id: id} ->
        Raxx.Patch.redirect("/customers/#{id}")
    end
  end

  def handle_request(%{path: [], method: :POST, body: body}, _env) do
    form = Map.get(body, "session")
    case {:ok, %{email: form["email"], password: form["password"]}} do
      {:ok, data} ->
        case UM.Accounts.authenticate(data) do
          {:ok, customer} ->
            target = Map.get(body, "target", "/customers/#{customer.id}")
            Raxx.Patch.redirect(target)
            |> with_flash(success: "Welcome back #{UM.Accounts.Customer.name(customer)}")
            |> with_session(%UM.Web.Session{customer_id: customer.id, currency_preference: customer.currency_preference})
          {:error, :invalid_credentials} ->
            Raxx.Patch.redirect("/sessions/new")
            |> with_flash(error: "Invalid login details")
        end
    end
  end

  def handle_request(_request = %{path: [], method: :DELETE}, _) do
    response = Raxx.Response.see_other("", [{"location", "/"}])
    Raxx.Session.Open.overwrite(nil, response)
  end

  def with_flash(request, flash) do
    flash = Enum.into(flash, %{})
    # {"location", url} = List.keyfind(request.headers, "location", 0)
    # [url] = String.split(url, "?") # DEBT this checks no query already set
    # flash = Poison.encode!(flash)
    # query = URI.encode_query(%{flash: flash})
    # headers = List.keyreplace(request.headers, "location", 0, {"location", url <> "?" <> query})
    %{request | headers: request.headers ++ [{"um-flash", flash}]}
  end

  def with_session(request, session) do
    %{request | headers: request.headers ++ [{"um-set-session", session}]}
  end
end
