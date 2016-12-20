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
end
