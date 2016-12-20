defmodule UM.Sales.Discount do
  defstruct [
    id: nil,
    code: nil,
    value: nil,
    allocation: nil,
    customer_allocation: nil,
    start_datetime: nil,
    end_datetime: nil
  ]
end
