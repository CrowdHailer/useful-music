defmodule UM.Accounts do
  defmodule Db do
    use Moebius.Database
  end

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Db, [Moebius.get_connection]),
    ]

    opts = [strategy: :one_for_one, name: UM.Accounts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
