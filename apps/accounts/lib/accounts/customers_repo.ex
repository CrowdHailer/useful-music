defmodule UM.Accounts.CustomersRepo do
  import Moebius.Query

  def insert(customer) do
    customer = Map.merge(customer, %{created_at: :now, updated_at: :now})
    customer = Enum.map(customer, fn(x) -> x end)
    q = db(:customers) |> insert(customer)
    case UM.Accounts.Db.run(q) do
      {:error, reason} ->
        {:error, reason}
      customer ->
        {:ok, customer}
    end
  end

  def update(customer = %{id: id}) when is_binary(id) do
    customer = Map.merge(customer, %{updated_at: :now})
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

  def index(page) do
    case db(:customers) |> sort(:id, :asc) |> UM.Accounts.Db.run do
      customers when is_list(customers) ->
        {:ok, Page.paginate(customers, page)}
    end
  end

  def fetch_by_id(id) do
    query = db(:customers) |> filter(id: id)
    case UM.Accounts.Db.first(query) do
      customer = %{id: ^id} ->
        {:ok, customer}
    end
  end

  def fetch_by_email(email) do
    customer = db(:customers) |> filter(email: email) |> UM.Accounts.Db.first
    case customer do
      nil ->
        {:error, :not_found}
      customer ->
        {:ok, customer}
    end
  end
end