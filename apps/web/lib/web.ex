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
    UM.Web.StylesheetsController.handle_request(%{request| path: rest}, env)
  end
  def handle_request(request = %{path: ["images" | rest]}, env) do
    UM.Web.ImagesController.handle_request(%{request| path: rest}, env)
  end

  def handle_request(request, env) do
    if Mix.env == :dev do
      IO.inspect(request)
    end
    try do
      {session, request} = UM.Web.Session.unpack(request)
      {:ok, request} = Raxx.Patch.set_header(request, "um-session", session)

      {flash, request} = UM.Web.Flash.from_request(request)
      {:ok, request} = Raxx.Patch.set_header(request, "um-flash", flash)

      {:ok, body} = case Raxx.Headers.content_type(request) do
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
          encoded_session = UM.Web.Session.encode!(session)
          cookie_string = Raxx.Cookie.new("raxx.session", encoded_session)
          |> Raxx.Cookie.set_cookie_string
          headers ++ [{"set-cookie", cookie_string}]
        nil ->
          headers
      end

      headers = case List.keytake(headers, "um-flash", 0) do
        {{"um-flash", flash}, headers} ->
          location = Raxx.Patch.response_location(%{headers: headers})
          qs = flash |> Poison.encode! |> URI.encode
          # DEBT location with existing query
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
    rescue
      exception ->
        Bugsnag.report(exception)
        stacktrace = System.stacktrace
        case Mix.env do
          :test ->
            :erlang.raise(:error, exception, stacktrace)
          :dev ->
            :erlang.raise(:error, exception, stacktrace)
            body = Raxx.DebugPage.html(request, {:error, exception, stacktrace}, :web)
            Raxx.Response.internal_server_error(body, [{"content-length", "#{:erlang.iolist_size(body)}"}])
          _ ->
            body = "See Bug Report"
            Raxx.Response.internal_server_error(body, [{"content-length", "#{:erlang.iolist_size(body)}"}])
        end
    end
  end

  defp endpoint(request = %{path: ["admin" | rest]}, env) do
    UM.Web.Admin.handle_request(%{request| path: rest}, env)
  end
  defp endpoint(request, env) do
    UM.Web.Public.handle_request(request, env)
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

  def fetch_session(request) do
    :proplists.get_value("um-session", request.headers, UM.Web.Session.new)
  end

  def fetch_flash(request) do
    :proplists.get_value("um-flash", request.headers, %UM.Web.Flash{})
  end
end
