# Store in cookie user_id, preferred_currency, shopping_basket_id
# Both currency preference and basket are features of a user when logged in
defmodule UM.Web.Session do
  def from_request(request) do
    {:ok, session} = Raxx.Session.Open.retrieve(request, %{})
    session = case Poison.decode(session) do
      {:ok, s = %{"customer_id" => id}} ->
        %{
          customer_id: id
        }
      {:error, :invalid} ->
        %{
          customer_id: nil,
          preferred_currency: "GBP"
        }
    end
    {session, request}
  end

  def get(request) do
    {"um-session", session} = List.keyfind(request.headers, "um-session", 0)
    session
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

  def guest_session?(session) do
    current_customer(session) == :guest
  end

  def preferred_currency(session) do
    case current_customer(session) do
      :guest ->
        session.preferred_currency || :GBP
      customer ->
        IO.inspect(customer)
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

  def customer_session(%{id: id}) do
    [{"um-session", %{customer_id: id}}]
  end
  def guest_session() do
    [{"um-session", %{customer_id: nil}}]
  end

  def external_session(data) do
    [{"cookie", "raxx.session="<>Poison.encode!(data)}]
  end
end
