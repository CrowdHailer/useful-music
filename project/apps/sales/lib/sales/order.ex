defmodule UM.Sales.Order do
  defstruct [
    id: nil,
    status: :pending # can be ['pending', 'processing', 'succeded', 'failed']
  ]
end
