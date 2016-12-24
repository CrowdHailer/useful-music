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

  defstruct [:customer_id, :customer, :currency_preference, :shopping_basket_id, :shopping_basket]
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
        {:ok, session} = Raxx.Session.Open.retrieve(request, %{})
        session = case decode(session) do
          {:ok, session} ->
            session
          _ ->
            %{
              customer_id: nil,
              currency_preference: "GBP",
              shopping_basket_id: nil
            }
        end
        # DEBT delete session from cookies
        {session, request}
    end
  end

  def decode(string) do
    case Poison.decode(string) do
      {:ok, raw} ->
        {:ok, %__MODULE__{
          customer_id: Map.get(raw, "customer_id"),
          currency_preference: Map.get(raw, "currency_preference"),
          shopping_basket_id: Map.get(raw, "shopping_basket_id")
        }}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def load_customer(session) do
    Map.merge(session, %{customer: current_customer(session)})
  end

  # current customer looks up customer
  def current_customer(%{account: customer}) when customer != nil do
    customer
  end
  def current_customer(%{customer_id: nil}) do
    :guest
  end
  def current_customer(%{customer_id: id}) do
    UM.Accounts.fetch_customer(id) || :guest
  end

  def customer_account_url(session) do
    case current_customer(session) do
      :guest ->
        nil
      %{id: id} ->
        "/customers/#{id}"
    end
  end

  def guest_session?(session) do
    current_customer(session) == :guest
  end


  def checkout_price(session) do
    0
  end

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
    opts = Enum.into(opts, %{})
    currency = Map.get(opts, :currency_preference, "GBP")
    [{"um-session", %__MODULE__{customer_id: nil, currency_preference: currency}}]
  end

  def external_session(data) do
    [{"cookie", "raxx.session="<>Poison.encode!(data)}]
  end
end
