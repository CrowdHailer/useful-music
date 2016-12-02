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

  import Moebius.Query

  def all_customers do
    db(:customers) |> Db.run
  end

  def signup_customer(customer) do
    customer = Map.merge(%{id: Utils.random_string(16)}, customer)
    customer = Enum.map(customer, fn(x) -> x end)
    q = db(:customers) |> insert(customer)
    Db.run(q)
  end

  def fetch_customer(id) do
    db(:customers) |> filter(id: id) |> Db.first
  end
end
