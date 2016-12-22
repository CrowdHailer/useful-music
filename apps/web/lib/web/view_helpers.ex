defmodule UM.Web.ViewHelpers do

  def logged_in?(session) do
    !UM.Web.Session.guest_session?(session)
  end

  def user_country(session) do
    nil # TODO
  end

  def currency_preference(session) do
    UM.Web.Session.currency_preference(session)
  end

  def user_vat_rate(session) do
    120 # TODO
  end

  def user_account_url(session) do
    UM.Web.Session.customer_account_url(session)
  end

  def user_shopping_basket_url(session) do
    case UM.Web.Session.shopping_basket_id(session) do
      nil ->
        "/shopping_baskets/__empty__"
      id ->
        "/shopping_baskets/#{id}"
    end
  end

  ####### ACCOUNTS #######

  def customer_name(customer) do
    # FIXME html escape because outside information
    UM.Accounts.Customer.name(customer)
  end

  def all_countries do
    [{"Great Britian", "GB"}]
  end

  ####### CATALOGUE #######

  def piece_product_name(piece) do
    UM.Catalogue.Piece.product_name(piece)
  end

  def piece_catalogue_number(piece) do
    UM.Catalogue.Piece.catalogue_number(piece)
  end

  def item_initial_price(%{initial_price: nil}), do: nil
  def item_initial_price(%{initial_price: pence}), do: pence / 100

  def item_discounted_price(%{discounted_price: nil}), do: nil
  def item_discounted_price(%{discounted_price: pence}), do: pence / 100

  def item_subsequent_price(item) do
    UM.Catalogue.Item.subsequent_price(item) / 100
  end

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

  defp stringify_option(term) do
    "#{term}"
    |> String.capitalize
    |> String.replace("_", " ")
  end

  ####### SALES #######

  def purchase_price(%{quantity: quantity, item: item}) do
    UM.Catalogue.Item.price_for(item, quantity) / 100
  end

  def number_of_purchases(_session) do
    # TODO number of purchases
    2
  end

  def current_basket_total(_session) do
    "£4.25" # TODO
  end

  def discount_value(%{value: pence}) do
    (pence || 0) / 100
  end

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
end
