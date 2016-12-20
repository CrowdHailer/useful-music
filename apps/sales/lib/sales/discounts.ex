defmodule UM.Sales.Discounts do
  import Moebius.Query
  def index_by_code(page) do
    query = db(:discounts) |> sort(:code, :asc)
    case Moebius.Db.run(query) do
      {:error, reason} ->
        {:error, reason}
      entries ->
        {:ok, Page.paginate(entries, page)}
    end
  end

  def insert(discount) do
    discount = Enum.map(discount, fn(x) -> x end)

    action = db(:discounts) |> insert(discount)
    case Moebius.Db.run(action) do
      discount = %{} ->
        {:ok, discount}
    end
  end

  def fetch_by_id(id) do
    query = db(:discounts) |> filter(id: id)

    case Moebius.Db.first(query) do
      discount = %{id: ^id} ->
        {:ok, discount}
    end
  end

  def update(discount = %{id: id}) do
    discount = Enum.map(discount, fn(x) -> x end)

    action = db(:discounts) |> filter(id: id) |> update(discount)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, record}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
