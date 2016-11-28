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
    # NOTE assets controller returns content-length etc
    UM.Web.Stylesheets.handle_request(%{request| path: rest}, env)
  end
  def handle_request(request = %{path: ["images" | rest]}, env) do
    # NOTE assets controller returns content-length etc
    UM.Web.Images.handle_request(%{request| path: rest}, env)
  end

  # This should end up as part of a Raxx Stack
  # Do handling form mapping here
  def handle_request(request, env) do
    {:ok, session} = Raxx.Session.Open.retrieve(request, %{})
    # Maybe this should be x-user-id
    {:ok, request} = Raxx.Session.set_header(request, "um-user-id", session)

    %{status: status, headers: headers, body: body} = endpoint(request, env)

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
      r = %{status: 200, body: content} ->
        %{r | body: UM.Web.Home.layout_page(content, @session)}
    end
  end
  defp endpoint(request = %{path: ["admin" | rest]}, env) do
    UM.Web.Admin.handle_request(%{request| path: rest}, env)
  end
  defp endpoint(request = %{path: ["about" | rest]}, env) do
    UM.Web.About.handle_request(%{request| path: rest}, %{
    shopping_basket: %{id: "TODO-basket", number_of_purchases: 2, price: 100},
    customer: %{id: "TODO-", guest?: true, working_currency: "GBP"},
    error: "Do this now TODO",
    success: nil
    })
  end

  defp endpoint(%{path: ["login"], method: :GET, headers: headers}, _) do
    body = """
      <h1>login</h1>
      <form action="/login" method="post">
        <input name="email">
        <button type="submit">login</button>
      </form>
    """
    Raxx.Response.ok(body)
  end

  defp endpoint(%{path: ["login"], method: :POST, headers: headers, body: body}, _) do
    credentials = Plug.Conn.Query.decode(body)
    session = credentials["email"]

    response = Raxx.Response.see_other("", [{"location", "/login"}])
    Raxx.Session.Open.overwrite(session, response, %{})
  end

  defp endpoint(request, env) do
    UM.Web.Home.handle_request(request, env)
  end

end
