defmodule Page do
  # Follow layout of scrivenor
  defstruct [
    page_size: nil,
    page_number: nil,
    entries: nil,
    total_entries: nil,
    total_pages: nil
  ]

  def paginate(collection, %{page_size: page_size, page_number: page_number})
    when page_size > 0 and page_number > 0 do
    total_entries = length(collection)

    offset = page_size * (page_number - 1)
    entries = Enum.slice(collection, offset, page_size)

    %__MODULE__{
      page_size: page_size,
      page_number: page_number,
      entries: entries,
      total_entries: total_entries,
      total_pages: Float.ceil(total_entries/page_size) |> round
    }
  end

  def first?(%{page_number: 1}) do
    true
  end
  def first?(%{page_number: n}) when n > 1 do
    false
  end

  def last?(%{page_number: count, total_pages: count}) do
    true
  end
  def last?(_) do
    false
  end

  def previous(%{page_number: 1}) do
    nil
  end
  def previous(%{page_number: n}) when n > 1 do
    n - 1
  end

  def next(%{page_number: count, total_pages: count}) do
    nil
  end
  def next(%{page_number: n}) do
    n + 1
  end
end
