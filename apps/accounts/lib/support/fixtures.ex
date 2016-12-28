defmodule UM.Accounts.Fixtures do
  import Moebius.Query

  def clear_db do
    db(:customers) |> delete |> UM.Accounts.Db.run
    db(:shopping_baskets) |> delete |> UM.Accounts.Db.run
    db(:orders) |> delete |> UM.Accounts.Db.run
    :ok
  end

  def my_account do
    db(:customers)
    |> insert(
      id: "peter",
      first_name: "Peter",
      last_name: "Saxton",
      email: "p@me.co",
      password: "password",
      country: "GB",
      admin: true,
    )
    |> UM.Accounts.Db.run
  end

  def grahams_account do
    db(:customers)
    |> insert(
      id: "graham",
      first_name: "Graham",
      last_name: "Lyons",
      email: "usefulmusic@gmail.com",
      password: "password",
      country: "GB",
      admin: true,
    )
    |> UM.Accounts.Db.run
  end

  # has a basket in progress
  def bugs_bunny do
    db(:customers)
    |> insert(
      id: "bugs-bunny-admin",
      first_name: "Bugs",
      last_name: "Bunny",
      email: "bugs@hotmail.com",
      password: "password",
      country: "GB",
      admin: true
    )
    |> UM.Accounts.Db.run
  end

  # Like joe blogs
  # Big spender
  # has completed order but no current basket
  # currency_preference = USD
  def jo_brand do
    db(:customers)
    |> insert(
      id: "jo-brand-customer",
      first_name: "Jo",
      last_name: "Brand",
      email: "jo@hotmail.com",
      password: "password",
      country: "GB",
      admin: false,
      currency_preference: "USD"
    )
    |> UM.Accounts.Db.run
  end
end
