# TODO namespace
defmodule Session do
  defstruct [customer: nil]
end

defmodule UM.Web do
  use Application

  @raxx_app {__MODULE__, []}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Ace.TCP, [{Raxx.Adapters.Ace.Handler, @raxx_app}, [port: 8080]])
    ]

    opts = [strategy: :one_for_one, name: UM.Web.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def handle_request(request = %{path: ["stylesheets" | rest]}, env) do
    UM.Web.Stylesheets.handle_request(%{request| path: rest}, env)
  end
  def handle_request(request = %{path: ["images" | rest]}, env) do
    UM.Web.Images.handle_request(%{request| path: rest}, env)
  end

  def handle_request(request, env) do
    {:ok, session} = Raxx.Session.Open.retrieve(request, %{})
    session = case Poison.decode(session) do
      {:ok, %{"customer" => %{"id" => id}}} ->
        struct(Session, %{customer: %{id: id}})
      {:error, :invalid} ->
        %Session{}
      _ ->
        %Session{}
    end
    {:ok, request} = Raxx.Patch.set_header(request, "um-session", session)

    {flash, request} = UM.Web.Flash.from_request(request)
    {:ok, request} = Raxx.Patch.set_header(request, "um-flash", flash)

    # Needs to make Raxx.Request.content/1 a never failing function 
    # request = case Raxx.Request.content(request) do
    #   {:ok, form} ->
    #     case Map.get(form, "_method") do
    #       "DELETE" ->
    #         %{request | method: :DELETE}
    #       _ ->
    #         request
    #     end
    #   _ ->
    #     request
    # end

    %{status: status, headers: headers, body: body} = endpoint(request, env)

    headers = case List.keytake(headers, "um-set-session", 0) do
      {{"um-set-session", session}, headers} ->
        headers ++ [{"set-cookie", Raxx.Cookie.new("raxx.session", Poison.encode!(session))
        |> Raxx.Cookie.set_cookie_string}]
      nil ->
        headers
    end

    headers = case List.keytake(headers, "um-flash", 0) do
      {{"um-flash", flash}, headers} ->
        # TODO pull location from headers
        location = Raxx.Patch.response_location(%{headers: headers})
        qs = flash |> Poison.encode! |> URI.encode
        # TODO location with existing query
        location = location <> "?flash=" <> qs
        List.keyreplace(headers, "location", 0, {"location", location})
      nil ->
        headers
    end

    headers = if !List.keymember?(headers, "content-length", 0) do
      headers ++ [{"content-length", "#{:erlang.iolist_size(body)}"}]
    else
      headers
    end

    headers = headers ++ [{"server", "workshop 14 limited"}]
    %Raxx.Response{status: status, headers: headers, body: body}
  end

  defp endpoint(request = %{path: ["admin" | rest]}, env) do
    UM.Web.Admin.handle_request(%{request| path: rest}, env)
  end

  @session %{
    shopping_basket: %{id: "TODO-basket", number_of_purchases: 2, price: 100},
    customer: %{id: "TODO-", guest?: true, working_currency: "GBP"},
    error: nil,
    success: nil
  }

  defp endpoint(request, env) do
    {"um-session", session} = List.keyfind(request.headers, "um-session", 0)
    {"um-flash", flash} = List.keyfind(request.headers, "um-flash", 0, {"um-flash", %{}})

    customer = case Map.get(session, :customer) do
      %{id: id} ->
        user = UM.Accounts.fetch_customer(id)
        Map.merge(user, %{working_currency: "GBP"})
      nil ->
        %{id: nil, working_currency: "GBP", name: ""}
    end
    page = Map.merge(@session, flash)
    page = Map.merge(page, %{customer: customer})
    case public_endpoint(request, env) do
      r = %{status: _, body: content} ->
        %{r | body: UM.Web.Home.layout_page(content, page)}
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

  def get_session(request) do
    case List.keyfind(request.headers, "um-session", 0) do
      {"um-session", session} ->
        session
      _ ->
        %Session{}
    end
  end
end
