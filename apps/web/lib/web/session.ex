defmodule UM.Web.Session do
  defmodule UnAuthenticated do
    # currency_preference = "USD" | "GBP" | "EUR"
    # shopping_basket = Maybe(ShoppingBasket)
    defstruct [shopping_basket: nil, currency_preference: nil]
  end
  defmodule Authenticated do
    # Always has a customer
    defstruct [account: nil]
  end

  def new do
    %__MODULE__.UnAuthenticated{currency_preference: "GBP"}
  end

  def logged_in?(%UnAuthenticated{}), do: false
  def logged_in?(%Authenticated{}), do: true

  def admin?(%Authenticated{account: %{admin: true}}), do: true
  def admin?(_), do: false

  def can_view_account?(%{account: %{admin: true}}, _), do: true
  def can_view_account?(%{account: %{id: id}}, id), do: true
  def can_view_account?(_, _), do: false

  def currency_preference(%UnAuthenticated{currency_preference: currency}), do: currency
  def currency_preference(%{account: %{currency_preference: currency}}), do: currency

  def login(session, customer) do
    customer = if customer.currency_preference do
      customer
    else
      customer = %{customer | currency_preference: session.currency_preference}
      {:ok, customer} = UM.Accounts.update_customer(customer)
      customer
    end
    %__MODULE__.Authenticated{account: customer}
  end

  def select_currency(session = %UnAuthenticated{}, currency) when currency in ["USD", "EUR", "GBP"] do
    %{session | currency_preference: currency}
  end
  def select_currency(session = %{account: customer}, currency) when currency in ["USD", "EUR", "GBP"] do
    {:ok, updated_customer} = UM.Accounts.update_customer(%{customer | currency_preference: currency})
    %{session | account: updated_customer}
  end

  def from_request(request) do
    case List.keyfind(request.headers, "um-session", 0) do
      {"um-session", session} ->
        {session, request}
      nil ->
        session = UM.Web.Session.new
        # DEBT delete session from cookies
        {session, request}
    end
  end

  def decode(string) do
    case Poison.decode(string) do
      {:ok, raw} ->
        # {:ok, %__MODULE__{
        #   customer_id: Map.get(raw, "customer_id"),
        #   currency_preference: Map.get(raw, "currency_preference"),
        #   shopping_basket_id: Map.get(raw, "shopping_basket_id")
        # }}
        new
      {:error, reason} ->
        {:error, reason}
    end
  end

# TODO move these to view helper combination of session and basket
  def checkout_price(session) do
    0
  end

# TODO move these to view helper combination of session and basket
  def number_of_basket_items(session) do
    0
  end

  def shopping_basket_id(session) do
    session.shopping_basket_id
  end

  def csrf_tag do
    "" # TODO
  end

  ## MOVE to test

  def customer_session(customer) do
    session =  new |> login(customer)
    [{"um-session", session}]
  end
  def guest_session(opts \\ []) do
    [{"um-session", new}]
  end

  def external_session(data) do
    [{"cookie", "raxx.session="<>Poison.encode!(data)}]
  end
end
