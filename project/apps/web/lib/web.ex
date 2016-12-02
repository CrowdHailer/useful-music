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
      {:error, invalid} ->
        %Session{}
    end
    {:ok, request} = Raxx.Session.set_header(request, "um-session", session)

    {flash, query} = Map.pop(request.query, "flash", Poison.encode!(%{}))
    flash = Poison.decode!(flash)
    flash = for {k, nil} <- [error: nil, success: nil], into: %{}  do
      {k, Map.get(flash, "#{k}")}
    end
    request = %{request | query: query}
    {:ok, request} = Raxx.Session.set_header(request, "um-flash", flash)

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

  @session %{
  shopping_basket: %{id: "TODO-basket", number_of_purchases: 2, price: 100},
  customer: %{id: "TODO-", guest?: true, working_currency: "GBP"},
  error: "Do this now TODO",
  success: nil
  }
  defp endpoint(request = %{path: ["customers" | rest]}, env) do
    case UM.Web.Customers.handle_request(%{request| path: rest}, env) do
      r = %{status: _, body: content} ->
        %{r | body: UM.Web.Home.layout_page(content, @session)}
    end
  end
  defp endpoint(request = %{path: ["admin" | rest]}, env) do
    UM.Web.Admin.handle_request(%{request| path: rest}, env)
  end
  defp endpoint(request = %{path: ["sessions" | rest]}, env) do
    UM.Web.SessionsController.handle_request(%{request| path: rest}, env)
  end
  defp endpoint(request = %{path: ["about" | rest]}, env) do
    UM.Web.About.handle_request(%{request| path: rest}, %{
    shopping_basket: %{id: "TODO-basket", number_of_purchases: 2, price: 100},
    customer: %{id: "TODO-", guest?: true, working_currency: "GBP"},
    error: "Do this now TODO",
    success: nil
    })
  end

  defp endpoint(request, env) do
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
