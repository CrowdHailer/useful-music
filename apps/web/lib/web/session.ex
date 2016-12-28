defmodule UM.Web.Session do
  defmodule UnAuthenticated do
    # currency_preference = "USD" | "GBP" | "EUR"
    # shopping_basket = Maybe(ShoppingBasket)
    defstruct [:shopping_basket, :currency_preference]
  end
  defmodule Authenticated do
    # Always has a customer
    defstruct [:account, :cart]
  end

  def new do
    %__MODULE__.UnAuthenticated{currency_preference: "GBP"}
  end

  def logged_in?(%UnAuthenticated{}), do: false
  def logged_in?(%Authenticated{}), do: true

  def current_customer(%Authenticated{account: customer}), do: customer
  def current_customer(%UnAuthenticated{}), do: nil

  def admin?(%Authenticated{account: %{admin: true}}), do: true
  def admin?(_), do: false

  def can_view_account?(%{account: %{admin: true}}, _), do: true
  def can_view_account?(%{account: %{id: id}}, id), do: true
  def can_view_account?(_, _), do: false

  def currency_preference(%UnAuthenticated{currency_preference: currency}), do: currency
  def currency_preference(%{account: %{currency_preference: currency}}), do: currency

  def shopping_basket(%UnAuthenticated{shopping_basket: shopping_basket}), do: shopping_basket || UM.Sales.Cart.empty
  def shopping_basket(%{cart: cart}), do: cart || UM.Sales.Cart.empty

  def cart(session) do
    shopping_basket(session)
  end

  def csrf_tag do
    "" # TODO
  end

  def login(session, customer) do
    customer = if customer.currency_preference do
      customer
    else
      customer = %{customer | currency_preference: session.currency_preference}
      # TODO saving customers properly handling shopping_baskets
      {:ok, customer} = UM.Accounts.update_customer(Map.delete(customer, :shopping_basket))
      customer
    end
    %__MODULE__.Authenticated{account: customer}
  end

  def select_currency(session = %UnAuthenticated{}, currency) when currency in ["USD", "EUR", "GBP"] do
    %{session | currency_preference: currency}
  end
  def select_currency(session = %{account: customer}, currency) when currency in ["USD", "EUR", "GBP"] do
    {:ok, updated_customer} = UM.Accounts.update_customer(%{customer | currency_preference: currency} |> Map.delete(:shopping_basket))
    %{session | account: updated_customer}
  end

  def update_shopping_basket(session = %UnAuthenticated{}, shopping_basket) do
    %{session | shopping_basket: shopping_basket}
  end
  def update_shopping_basket(session = %{account: customer}, shopping_basket) do
    {:ok, updated_customer} = UM.Accounts.update_customer(%{customer | shopping_basket_id: shopping_basket.id})
    %{session | account: updated_customer, cart: shopping_basket}
  end

  def unpack(request) do
    headers = request.headers
    {"cookie", cookie_string} = List.keyfind(headers, "cookie", 0, {"cookie", ""})
    cookies = Raxx.Cookie.parse([cookie_string])
    encoded_session = Map.get(cookies, "raxx.session", "")
    session = decode(encoded_session)
    {session, request}
  end

  def decode(string) do
    case Poison.decode(string) do
      {:ok, %{"account_id" => id}} ->
        {:ok, customer} = UM.Accounts.fetch_by_id(id)
        cart = case UM.Sales.CartsRepo.fetch_by_id(customer.shopping_basket_id || "") do
          {:ok, cart} ->
            cart
          {:error, :not_found} ->
            UM.Sales.Cart.empty
        end
        new |> login(customer) |> update_shopping_basket(cart)
      {:ok, raw} ->
        currency = Map.get(raw, "currency_preference", "GBP")
        new |> select_currency(currency)
      {:error, _reason} ->
        new
    end
  end

  def encode!(%Authenticated{account: %{id: id}}) do
    Poison.encode!(%{account_id: id})
  end
  def encode!(%UnAuthenticated{currency_preference: currency}) do
    Poison.encode!(%{currency_preference: currency})
  end

  ## MOVE to test

  def customer_session(customer) do
    session =  new |> login(customer)
    [{"um-session", session}]
  end
  def guest_session(opts \\ []) do
    opts = Enum.into(opts, %{})
    session = Map.merge(new, opts)
    [{"um-session", session}]
  end

  def external_session(session) do
    [{"cookie", "raxx.session=" <> encode!(session)}]
  end
end
