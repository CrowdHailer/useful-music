defmodule UM.Accounts do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(UM.Accounts.Db, [Moebius.get_connection]),
    ]

    opts = [strategy: :one_for_one, name: UM.Accounts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  import Moebius.Query

  def all_customers(page) do
    case db(:customers) |> UM.Accounts.Db.run do
      customers when is_list(customers) ->
        {:ok, Page.paginate(customers, page)}
    end
  end

  def signup_customer(customer) do
    customer = Map.merge(%{id: Utils.random_string(16)}, customer)
    customer = Enum.map(customer, fn(x) -> x end)
    q = db(:customers) |> insert(customer)
    UM.Accounts.Db.run(q)
  end

  # Move to CustomersRepo
  def fetch_by_id(id) do
    customer = %{id: ^id} = fetch_customer(id)
    {:ok, customer}
  end

  def fetch_customer(id) do
    db(:customers) |> filter(id: id) |> UM.Accounts.Db.first
  end

  def update_customer(customer = %{id: id}) when is_binary(id) do
    # DEBT insert requires a keyword list
    customer = Enum.map(customer, fn(x) -> x end)

    action = db(:customers)
    |> filter(id: id)
    |> update(customer)
    case UM.Accounts.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, record}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_by_email(email) do
    customer = db(:customers) |> filter(email: email) |> UM.Accounts.Db.first
    case customer do
      nil ->
        {:error, :not_found}
      customer ->
        {:ok, customer}
    end
  end

  def reset_password(data) do
    {:ok, customer} = find_by_email(data.email)
    {:ok, updated} =UM.Accounts.Customer.reset_password(customer, data)
    UM.Accounts.update_customer(updated)
  end

  def authenticate(%{email: email, password: password}) do
    customer = db(:customers) |> filter(email: email) |> UM.Accounts.Db.first
    case customer && customer.password do
      ^password ->
        {:ok, customer}
      _ ->
        {:error, :invalid_credentials}
    end
  end

  def create_password_reset(email) do
    # could look for exisiting reset tokens all in one query
    action = db(:customers)
    |> filter(email: email)
    |> update(password_reset_token: Utils.random_string(24), password_reset_created_at: :now)
    case UM.Accounts.Db.run(action) do
      nil ->
        {:error, :no_customer}
      customer ->
        {:ok, customer}
    end
  end
end
