defmodule UM.Sales.DiscountsRepo do
  # check_allocation(discount) -> {:ok, remaining}
  # check_customer_allocation(discount)
  import Moebius.Query

  def insert(discount) do
    discount = Map.merge(discount, %{created_at: :now, updated_at: :now})
    discount = pack(discount)
    discount = Enum.map(discount, fn(x) -> x end)

    action = db(:discounts) |> insert(discount)
    case Moebius.Db.run(action) do
      record = %{} ->
        {:ok, unpack(record)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def update(discount = %{id: id}) do
    discount = Map.merge(discount, %{updated_at: :now})
    discount = pack(discount)
    discount = Enum.map(discount, fn(x) -> x end)

    action = db(:discounts) |> filter(id: id) |> update(discount)
    case Moebius.Db.run(action) do
      record = %{id: ^id} ->
        {:ok, unpack(record)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp pack(discount) do
    {:ok, value} = Map.fetch(discount, :value)
    case value do
      # discounts should only ever have value set in pounds
      %Money{currency: :GBP, amount: pence} ->
        %{discount | value: pence}
    end
  end

  defp unpack(record) do
    {:ok, pence} = Map.fetch(record, :value)
    value = Money.new(pence, :GBP)
    record = %{record | value: value}
    discount = struct(UM.Sales.Discount, record)
  end

  def index_by_code(page) do
    query = db(:discounts) |> sort(:code, :asc)
    case Moebius.Db.run(query) do
      {:error, reason} ->
        {:error, reason}
      entries ->
        {:ok, Page.paginate(entries, page)}
    end
  end

  def fetch_by_id(id) do
    query = db(:discounts) |> filter(id: id)

    case Moebius.Db.first(query) do
      discount = %{id: ^id} ->
        {:ok, discount}
    end
  end

  def fetch_available_code(code) do
    # TODO check number redeemed etc
    query = db(:discounts) |> filter(code: code)
    case Moebius.Db.first(query) do
      discount = %{id: _id} ->
        {:ok, discount}
      nil ->
        {:error, :not_found}
    end
  end

  def total_redemptions_for(%{id: id}) do
    # TODO count
    0
  end
end
