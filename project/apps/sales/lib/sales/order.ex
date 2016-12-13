defmodule UM.Sales.Order do
  @moduledoc """
  Existing system has 4 states for an order ['pending', 'processing', 'succeded', 'failed']
  Pending is almost immediatly replaced by processing

  A shopping basket is just a pending order, particularly as an order can have more than one transaction
  purchase can also be thought of as order line
  """
  defstruct [
    id: nil,
    status: :pending, # can be ['pending', 'processing', 'succeded', 'failed']
    purchases: %{}
  ]

  def new do
    %__MODULE__{
      id: Utils.random_string(16)
    }
  end

  def empty?(order), do: number_of_lines(order) == 0

  def number_of_lines(%{purchases: purchases}), do: Enum.count(purchases)

  def number_of_units(%{purchases: purchases}) do
    Enum.reduce(purchases, 0, fn
      ({_item_id, %{quantity: n}}, total) ->
        total + n
    end)
  end

  def edit_line(order = %{purchases: purchases}, %{item: item, quantity: quantity}) do
    purchases = Map.put(purchases, item.id, %{item: item, quantity: quantity})
    %{order | purchases: purchases}
  end

end
