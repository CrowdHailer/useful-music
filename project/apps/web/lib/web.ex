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
    UM.Web.Assets.handle_request(%{request| path: rest}, env)
  end

  def handle_request(%{path: []} ,_env) do
    body = "Useful music"
    Raxx.Response.ok(body, [{"content-length", "#{:erlang.iolist_size(body)}"}])
  end

  def handle_request(_, _) do
    Raxx.Response.not_found()
  end
end
