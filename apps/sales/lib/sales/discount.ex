defmodule UM.Sales.Discount do
  defmodule Zero do
    defstruct [id: nil]
  end
  defstruct [
    id: nil,
    code: nil,
    value: nil,
    allocation: nil,
    customer_allocation: nil,
    start_datetime: nil,
    end_datetime: nil
  ]

  def zero, do: %Zero{}

  def value(%Zero{}), do: 0
  def value(%{value: value}), do: value

  def check_availabile(%Zero{}, _) do
    {:ok, %Zero{}}
  end

  def code() do
    code
  end
  # pending?
  # expired?
end
