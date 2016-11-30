defmodule UM.Customers do
  import Moebius.Query
  # rename search

  def all do
    _ = Moebius.Db.start_link(Moebius.get_connection)
    db(:customers) |> Moebius.Db.run
  end
  def find_by_email(emails) do

  end

  def insert(customer) do
    customer = Map.merge(%{id: random_string(16)}, customer)
    customer = Enum.map(customer, fn(x) -> x end)
    q = db(:customers) |> insert(customer)
    IO.inspect(q)
    Moebius.Db.run(q)
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
