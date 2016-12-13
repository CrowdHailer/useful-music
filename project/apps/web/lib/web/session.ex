# Store in cookie user_id, currency_preference, shopping_basket_id
# Both currency preference and basket are features of a user when logged in

# could have customer: %{$ref: id}
defmodule UM.Web.Session do
  defstruct [:customer_id, :customer, :currency_preference, :shopping_basket_id, :shopping_basket]
  def from_request(request) do
    {:ok, session} = Raxx.Session.Open.retrieve(request, %{})
    session = case Poison.decode(session) do
      {:ok, raw} ->
        %__MODULE__{
          customer_id: Map.get(raw, "customer_id"),
          currency_preference: Map.get(raw, "currency_preference"),
          shopping_basket_id: Map.get(raw, "shopping_basket_id")
        }
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

  def get(request) do
    case List.keyfind(request.headers, "um-session", 0) do
      {"um-session", session} ->
        session
      nil ->
        %__MODULE__{
          customer_id: nil,
          currency_preference: "GBP",
          shopping_basket_id: nil
        }
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
    UM.Accounts.fetch_customer(id)
  end

  def customer_account_url(session) do
    case current_customer(session) do
      :guest ->
        nil
      %{id: id} ->
        "/customer/#{id}"
    end
  end

  def guest_session?(session) do
    current_customer(session) == :guest
  end

  def currency_preference(session) do
    case current_customer(session) do
      :guest ->
        session.currency_preference
      customer ->
        customer.currency_preference
    end
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

  def can_view_customer?(session, customer_id) do
    session.customer_id == customer_id || admin?(session)
  end

  ## MOVE to test

  def customer_session(customer) do
    [{"um-session", %__MODULE__{customer_id: customer.id, currency_preference: Map.get(customer, :currency_preference, "GBP")}}]
  end
  def guest_session(opts \\ []) do
    opts = Enum.into(opts, %{})
    currency = Map.get(opts, :currency_preference, "GBP")
    [{"um-session", %{customer_id: nil, currency_preference: currency}}]
  end

  def external_session(data) do
    [{"cookie", "raxx.session="<>Poison.encode!(data)}]
  end
end
