defmodule UM.Accounts.CustomersRepo do
  import Moebius.Query

  def insert(customer) do
    customer = Map.merge(customer, %{created_at: :now, updated_at: :now})
    customer = pack(customer)
    customer = Enum.map(customer, fn(x) -> x end)
    q = db(:customers) |> insert(customer)
    case UM.Accounts.Db.run(q) do
      {:error, reason} ->
        {:error, reason}
      record ->
        {:ok, unpack(record)}
    end
  end

  def update(customer = %{id: id}) when is_binary(id) do
    customer = Map.merge(customer, %{updated_at: :now})
    customer = pack(customer)
    customer = Enum.map(customer, fn(x) -> x end)

    action = db(:customers)
    |> filter(id: id)
    |> update(customer)
    case UM.Accounts.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, unpack(record)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp pack(customer) do
    if Map.has_key?(customer, :password) do
      customer = Map.delete(customer, :password_hash)
      {password, customer} = Map.pop(customer, :password)
      Map.merge(customer, %{password: Comeonin.Bcrypt.hashpwsalt(password)})
    else
      {password_hash, customer} = Map.pop(customer, :password_hash)
      if password_hash do
        Map.merge(customer, %{password: password_hash})
      else
        customer
      end
    end
  end

  defp unpack(record) do
    {hash, record} = Map.pop(record, :password)
    Map.merge(record, %{password_hash: hash})
  end

  def index(page) do
    case db(:customers) |> sort(:id, :asc) |> UM.Accounts.Db.run do
      records when is_list(records) ->
        customers = Enum.map(records, &unpack/1)
        {:ok, Page.paginate(customers, page)}
    end
  end

  def fetch_by_id(id) do
    query = db(:customers) |> filter(id: id)
    case UM.Accounts.Db.first(query) do
      record = %{id: ^id} ->
        {:ok, unpack(record)}
    end
  end

  def fetch_by_email(email) do
    customer = db(:customers) |> filter(email: email) |> UM.Accounts.Db.first
    case customer do
      nil ->
        {:error, :not_found}
      record ->
        {:ok, unpack(record)}
    end
  end
end
