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

  alias UM.Accounts.CustomersRepo

  def signup_customer(customer) do
    customer = Map.merge(%{id: Utils.random_string(16)}, customer)
    UM.Accounts.CustomersRepo.insert(customer)
  end

  def reset_password(data) do
    {:ok, customer} = CustomersRepo.fetch_by_email(data.email)
    {:ok, updated} = UM.Accounts.Customer.reset_password(customer, data)
    CustomersRepo.update(updated)
  end

  def authenticate(%{email: email, password: password}) do
    case CustomersRepo.fetch_by_email(email) do
      {:ok, customer} ->
        UM.Accounts.Customer.check_password(customer, password)
      {:error, :not_found} ->
        {:error, :invalid_credentials}
    end
  end

  def create_password_reset(email) do
    case CustomersRepo.fetch_by_email(email) do
      {:ok, customer} ->
        updated = Map.merge(customer, %{
          password_reset_token: Utils.random_string(24),
          password_reset_created_at: :now
        })
        CustomersRepo.update(updated)
      {:error, reason} ->
        {:error, reason}
    end
  end
end
