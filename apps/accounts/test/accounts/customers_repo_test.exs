defmodule UM.Accounts.CustomersRepoTest do
  use ExUnit.Case

  setup do
    :ok = UM.Accounts.Fixtures.clear_db
    :ok = UM.Catalogue.Fixtures.clear_db
  end

  defp defaults(extra \\ []) do
    extra = Enum.into(extra, %{})
    [country] = Countries.filter_by(:alpha2, "GB")
    %{
      id: "jo-brand-customer",
      first_name: "Jo",
      last_name: "Brand",
      email: "jo@hotmail.com",
      password: "password",
      country: country,
      admin: false
    } |> Map.merge(extra)
  end

  alias UM.Accounts.CustomersRepo, as: Repo

  test "inserted record has a created_at set" do
    {:ok, customer} = Repo.insert(defaults)
    |> IO.inspect
    assert customer.created_at
    assert customer.updated_at
  end

  test "inserted record has password encrypted" do
    {:ok, customer} = Repo.insert(defaults(password: "password"))
    refute Map.has_key?(customer, :password)
  end

  #DEBT not really a repo test
  test "can authenticate with correct password" do
    {:ok, customer} = Repo.insert(defaults(password: "password"))
    assert {:ok, customer} = UM.Accounts.Customer.check_password(customer, "password")
    assert customer.last_login_at == :now
  end

  #DEBT not really a repo test
  test "can't authenticate with incorrect password" do
    {:ok, customer} = Repo.insert(defaults(password: "password"))
    assert {:error, :invalid_credentials} = UM.Accounts.Customer.check_password(customer, "other_password")
  end
end
