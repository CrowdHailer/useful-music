defmodule UM.Web.Session.JSON do
  import UM.Web.Session
  alias UM.Web.Session.{Authenticated, UnAuthenticated}

  def decode(string) do
    case Poison.decode(string) do
      {:ok, %{"account_id" => id}} ->
        {:ok, customer} = UM.Accounts.CustomersRepo.fetch_by_id(id)
        cart = case UM.Sales.CartsRepo.fetch_by_id(customer.shopping_basket_id || "") do
          {:ok, cart} ->
            cart
          {:error, :not_found} ->
            nil
        end
        session = new |> login(customer)
        session = if cart do
          update_shopping_basket(session, cart)
        end || session
        session
      {:ok, raw} ->
        currency = Map.get(raw, "currency_preference", "GBP")
        cart_id = Map.get(raw, "cart_id")
        cart = case UM.Sales.CartsRepo.fetch_by_id(cart_id || "") do
          {:ok, cart} ->
            cart
          {:error, :not_found} ->
            nil
        end
        new |> select_currency(currency) |> update_shopping_basket(cart)
      {:error, _reason} ->
        new
    end
  end

  def encode!(%Authenticated{account: %{id: id}}) do
    Poison.encode!(%{account_id: id})
  end
  def encode!(%UnAuthenticated{currency_preference: currency, cart: cart}) do
    if cart do
      Poison.encode!(%{currency_preference: currency, cart_id: cart.id})
    else
      Poison.encode!(%{currency_preference: currency})
    end
  end
end
