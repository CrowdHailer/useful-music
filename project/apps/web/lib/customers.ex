defmodule UM.Customers do
  import Moebius.Query
  # rename search

  def all do
    db(:customers) |> Moebius.Db.run
  end

  def fetch(id) do
    db(:customers) |> filter(id: id) |> Moebius.Db.first
  end
  def find_by_email(_email) do

  end

  def insert(customer) do
    customer = Map.merge(%{id: Utils.random_string(16)}, customer)
    customer = Enum.map(customer, fn(x) -> x end)
    q = db(:customers) |> insert(customer)
    Moebius.Db.run(q)
  end
end
