defmodule UM.Web do
  use Application

  @raxx_app {__MODULE__, []}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = System.get_env("PORT") || "8080"
    {port, ""} = Integer.parse(port)
    children = [
      worker(Ace.TCP, [{Raxx.Adapters.Ace.Handler, @raxx_app}, [port: port]])
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
    if Mix.env == :dev do
      IO.inspect(request)
    end

    {session, request} = UM.Web.Session.from_request(request)
    {:ok, request} = Raxx.Patch.set_header(request, "um-session", session)

    {flash, request} = UM.Web.Flash.from_request(request)
    {:ok, request} = Raxx.Patch.set_header(request, "um-flash", flash)

    {:ok, body} = case Raxx.Request.content_type(request) do
      {"application/x-www-form-urlencoded", _} ->
        URI2.Query.decode(request.body)
      {"multipart/form-data", "boundary=" <> boundary} ->
        {:ok, kvs} = Raxx.Parsers.Multipart.parse_body(request.body, boundary)
        URI2.Query.build_nested(kvs)
      :undefined ->
        {:ok, request.body}
    end

    request = %{request | body: body}

    request = Raxx.MethodOverride.override_method(request)

    %{status: status, headers: headers, body: body} = endpoint(request, env)

    headers = case List.keytake(headers, "um-set-session", 0) do
      {{"um-set-session", session}, headers} ->
        session = %{
          customer_id: session.customer_id,
          currency_preference: session.currency_preference,
          shopping_basket_id: session.shopping_basket_id
        }
        cookie_string = Raxx.Cookie.new("raxx.session", Poison.encode!(session))
        |> Raxx.Cookie.set_cookie_string
        headers ++ [{"set-cookie", cookie_string}]
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
  defp endpoint(request, env) do
    UM.Web.Public.handle_request(request, env)
  end
end
