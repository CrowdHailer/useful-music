defmodule UM.Accounts.CustomersRepoTest do
  use ExUnit.Case

  setup do
    :ok = UM.Accounts.Fixtures.clear_db
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  defp defaults(extra \\ []) do
    extra = Enum.into(extra, %{})
    %{
      id: "jo-brand-customer",
      first_name: "Jo",
      last_name: "Brand",
      email: "jo@hotmail.com",
      password: "password",
      country: "GB",
      admin: false
    } |> Map.merge(extra)
  end

  alias UM.Accounts.CustomersRepo, as: Repo

  test "inserted record has a created_at set" do
    {:ok, customer} = Repo.insert(defaults)
    assert customer.created_at
    assert customer.updated_at
  end

  test "inserted record has password encrypted" do
    {:ok, customer} = Repo.insert(defaults(password: "password"))
    refute Map.has_key?(customer, :password)
  end

  test "can authenticate with correct password" do
    {:ok, customer} = Repo.insert(defaults(password: "password"))
    assert UM.Accounts.Customer.check_password(customer, "password")
    refute UM.Accounts.Customer.check_password(customer, "other_password")
  end
end
