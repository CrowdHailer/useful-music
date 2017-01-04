defmodule UM.Sales.OrdersRepoTest do
  use ExUnit.Case

  alias UM.Sales.OrdersRepo, as: Repo
  alias UM.Sales.Order

  setup do
    UM.Accounts.Fixtures.clear_db
    UM.Catalogue.Fixtures.clear_db
    :ok
  end

  # add a discount
  test "" do
    _ = UM.Catalogue.Fixtures.garden_tiger
    {:ok, record} = UM.Sales.create_shopping_basket
    {:ok, record} = UM.Sales.edit_purchases(record, %{"garden-audio-part" => 3})
    {:ok, cart} = UM.Sales.CartsRepo.fetch_by_id(record.id)

    bugs = UM.Accounts.Fixtures.bugs_bunny

    # {:ok, order} = Cart.checkout_at(cart, bugs, :now)
    # {:ok, order} = Cart.checkout(cart, bugs)
    # order = %{order | id: Utils.random_string(16), created_at: :now, updated_at: :now}

    {:ok, order} = Repo.insert(%Order{
      id: Utils.random_string(16),
      state: "pending",
      cart_total: Money.new(100, :GBP),
      discount_value: Money.new(0, :GBP),
      payment_gross: Money.new(100, :GBP),
      payment_net: Money.new(120, :GBP),
      tax_payment: Money.new(20, :GBP),
      cart: cart,
      customer_id: bugs.id,
      created_at: :now,
      updated_at: :now
    })
    # |> IO.inspect

    {:ok, order} = Repo.insert(%Order{
      id: Utils.random_string(16),
      state: "succeded",
      cart_total: Money.new(100, :GBP),
      discount_value: Money.new(100, :GBP),
      payment_gross: Money.new(0, :GBP),
      payment_net: Money.new(0, :GBP),
      tax_payment: Money.new(0, :GBP),
      cart: cart,
      customer_id: bugs.id,
      created_at: :now,
      updated_at: :now,
      completed_at: :now
    })
    |> IO.inspect

    Repo.available_orders(bugs)
    |> IO.inspect

  end
end
