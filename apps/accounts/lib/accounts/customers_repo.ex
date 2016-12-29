defmodule UM.Accounts.CustomersRepo do
  import Moebius.Query

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
end
