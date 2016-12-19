defmodule UM.Sales.Discount do
  defstruct [
    code: "",
    value: 0,
    allocation: 0,
    customer_allocation: 0,
    start_datetime: 0,
    end_datetime: 0
  ]
end
