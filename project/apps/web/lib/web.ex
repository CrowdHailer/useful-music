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

  def handle_request(request = %{path: ["assets" | rest]}, env) do
    # NOTE assets controller returns content-length etc
    UM.Web.Assets.handle_request(%{request| path: rest}, env)
  end

  # This should end up as part of a Raxx Stack
  def handle_request(request, env) do
    # Do handling form mapping here
    headers = request.headers
    {"cookie", cookie_string} = List.keyfind(headers, "cookie", 0, {"cookie", ""})
    # TODO pass in a single string
    id = Raxx.Cookie.parse([cookie_string]) |> Map.get("user.id", "")

    # Maybe this should be x-user-id
    headers = headers ++ [{"um-user-id", id}]
    request = %{request| headers: headers}
    %{status: status, headers: headers, body: body} = endpoint(request, env)

    headers = if !List.keymember?(headers, "content-length", 0) do
      headers ++ [{"content-length", "#{:erlang.iolist_size(body)}"}]
    else
      headers
    end

    headers = headers ++ [{"server", "workshop 14 limited"}]

    %Raxx.Response{status: status, headers: headers, body: body}
  end

  defp endpoint(request = %{path: ["customers" | rest]}, env) do
    UM.Web.Customers.handle_request(%{request| path: rest}, env)
  end

  defp endpoint(%{path: []} ,_env) do
    body = "Useful music"
    Raxx.Response.ok(body, [{"content-length", "#{:erlang.iolist_size(body)}"}])
  end

  defp endpoint(%{path: ["login"], method: :GET, headers: headers}, _) do
    IO.inspect(headers)
    body = """
      <h1>login</h1>
      <form action="/login" method="post">
        <input name="email">
        <button type="submit">login</button>
      </form>
    """
    Raxx.Response.ok(body)
  end
  defp endpoint(%{path: ["login"], method: :POST, headers: headers}, _) do
    set_cookie_string = Raxx.Cookie.new("user.id", "hi")
    |> Raxx.Cookie.set_cookie_string
    |> IO.inspect
    Raxx.Response.see_other("", [
      {"set-cookie", set_cookie_string},
      {"location", "/login"}])
    # TODO redirect is broken
    # Raxx.Response.redirect("body")
    # |> Raxx.Response.set_cookie("user.id", "hi")
  end

  defp endpoint(_, _) do
    Raxx.Response.not_found("not found")
  end
end
