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

  defmodule Assets do
    asset_dir = Path.expand("./assets", Path.dirname(__ENV__.file))
    assets = Path.expand("./**/*", asset_dir) |> Path.wildcard

    # other things this should do are
    # - send a response for a HEAD request
    # - return a method not allowed for other HTTP methods
    # - return content error from accept headers
    # - gzip encoding
    # - have an overwritable not_found function
    # - cache control time
    # - Etags
    # - filtered reading of a file
    # - set a maximum size of file to bundle into the code.

    for asset <- assets do
      case File.read(asset) do
        {:ok, content} ->
          relative = Path.relative_to(asset, asset_dir)
          path = Path.split(relative)
          mime = MIME.from_path(asset)

          def handle_request(%{path: unquote(path)}, _) do
            Raxx.Response.ok(unquote(content), [
              {"content-length", "#{:erlang.iolist_size(unquote(content))}"},
              {"content-type", unquote(mime)}
            ])
          end

        {:error, reason} ->
          IO.inspect(reason)
      end
    end

    def handle_request(_, _) do
      Raxx.Response.not_found()
    end
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
