defmodule UM.Web.ViewHelpers do
  alias UM.Web.Session

  def as_pounds(%Money{amount: pence, currency: :GBP}) do
    pence / 100
  end
  def as_pounds(nil) do
    nil
  end

  def in_local_currency(money, session) do
    local_currency = currency_preference(session)
    exchange_currency(money, local_currency)
  end

  def exchange_currency(money = %Money{amount: _pence, currency: :GBP}, "GBP") do
    money
  end
  def exchange_currency(%Money{amount: pence, currency: :GBP}, "EUR") do
    {:ok, rate} = Application.fetch_env(:sales, :eur_exchange_rate)
    Money.new(round(pence * rate), :EUR)
  end
  def exchange_currency(%Money{amount: pence, currency: :GBP}, "USD") do
    {:ok, rate} = Application.fetch_env(:sales, :usd_exchange_rate)
    Money.new(round(pence * rate), :USD)
  end

  def logged_in?(session) do
    Session.logged_in?(session)
  end

  def user_name(session) do
    user = Session.current_customer(session)
    customer_name(user)
  end

  def user_country(session) do
    if logged_in?(session) do
      customer = Session.current_customer(session)
      [country] = Countries.filter_by(:alpha2, customer.country)
      country.name
    end
  end

  def currency_preference(session) do
    Session.currency_preference(session)
  end

  def user_vat_rate(session) do
    if logged_in?(session) do
      customer = Session.current_customer(session)
      [country] = Countries.filter_by(:alpha2, customer.country)
      country
      |> Map.get(:vat_rates)
      |> List.keyfind('standard', 0)
      |> elem(1)
    end
  end

  # This is the price without vat
  def checkout_price(session) do
    session
    |> Session.cart
    |> UM.Sales.Cart.payment_gross
    |> in_local_currency(session)
  end

  def number_of_purchases(session) do
    cart = Session.cart(session)
    UM.Sales.Cart.number_of_lines(cart)
  end

  def user_account_url(session) do
    case Session.current_customer(session) do
      nil -> "/customers/__guest__"
      %{id: id} -> "/customers/#{id}"
    end
  end

  def user_shopping_basket_url(session) do
    case Session.cart(session).id do
      nil ->
        "/shopping_baskets/__empty__"
      id ->
        "/shopping_baskets/#{id}"
    end
  end

  def current_shopping_basket_id(session) do
    case Session.cart(session).id do
      nil ->
        "__empty__"
      id ->
        id
    end
  end

  def quantity_in_cart(session, item) do
    cart = Session.cart(session)
    ((cart.purchases[item.id] || %{}) |> Map.get(:quantity)) || 0
  end

  ####### ACCOUNTS #######

  def customer_name(customer) do
    # FIXME html escape because outside information
    UM.Accounts.Customer.name(customer)
  end

  def all_countries do
    for %{alpha2: code, name: name} <- Countries.all do
      {"#{name}", "#{code}"}
    end
    |> Enum.sort_by(fn({name, _}) -> name end)
  end

  ####### CATALOGUE #######

  def piece_product_name(piece) do
    UM.Catalogue.Piece.product_name(piece)
  end

  def piece_catalogue_number(piece) do
    UM.Catalogue.Piece.catalogue_number(piece)
  end

  def item_discounted_price(%{discounted_price: nil}), do: nil
  def item_discounted_price(%{discounted_price: pence}), do: pence

  def item_asset_url(item) do
    UM.Catalogue.ItemStorage.url({item.asset, item}, :original, signed: true)
  end

  def instruments do
    # Maybe belongs at Catalogue layer
    UM.Catalogue.Piece.all_instruments
    |> Enum.map(&stringify_option/1)
  end

  def levels do
    UM.Catalogue.Piece.all_levels
    |> Enum.map(&stringify_option/1)
  end

  def categories do
    UM.Catalogue.Piece.all_categories
    |> Enum.map(&stringify_option/1)
  end

  def stringify_option(term) do
    "#{term}"
    |> String.capitalize
    |> String.replace("_", " ")
  end

  ####### SALES #######

  def discount_start_datetime(%{start_datetime: nil}) do
    ""
  end
  def discount_start_datetime(%{start_datetime: datetime}) do
    postgres_datetime_to_iso8601(datetime)
  end

  def discount_end_datetime(%{end_datetime: nil}) do
    ""
  end
  def discount_end_datetime(%{end_datetime: datetime}) do
    postgres_datetime_to_iso8601(datetime)
  end

  defp postgres_datetime_to_iso8601(datetime) do
    [date, _time] = String.split(datetime, " ")
    date
  end

  def order_expiry_date(order) do
    "4 days later" # TODO
  end
end
