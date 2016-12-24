defmodule UM.Web.Session do
  defstruct [:customer_id, :customer, :currency_preference, :shopping_basket_id, :shopping_basket]
  def new do
    %__MODULE__{currency_preference: "GBP"}
  end

  def logged_in?(session) do
    !UM.Web.Session.guest_session?(session)
  end

  def admin?(session) do
    case current_customer(session) do
      :guest ->
        false
      %{admin: true} ->
        true
      %{admin: false} ->
        false
    end
  end

  def can_view_account?(session, customer_id) do
    session.customer_id == customer_id || admin?(session)
  end

  def currency_preference(session) do
    case current_customer(session) do
      :guest ->
        session.currency_preference
      customer ->
        customer.currency_preference
    end
  end

  def login(session, customer) do
    currency_preference = if customer.currency_preference do
      customer.currency_preference
    else
      customer = %{customer | currency_preference: session.currency_preference}
      # DEBT check return values
      UM.Accounts.update_customer(customer)
      customer.currency_preference
    end
    %__MODULE__{customer_id: customer.id, currency_preference: currency_preference, customer: customer}
  end

  def select_currency(session, currency) do
    if logged_in?(session) do
      customer = current_customer(session)
      updated_customer = %{customer | currency_preference: currency}
      # DEBT check return values
      UM.Accounts.update_customer(updated_customer)
      %{session | currency_preference: currency, customer: updated_customer}
    else
      %{session | currency_preference: currency}
    end
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
  def current_customer(%{customer: customer}) when customer != nil do
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
    session =  %__MODULE__{customer_id: customer.id, currency_preference: Map.get(customer, :currency_preference, "GBP")}
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
