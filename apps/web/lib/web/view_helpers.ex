defmodule UM.Web.ViewHelpers do
  alias UM.Web.Session
  alias UM.Sales.Cart, as: ShoppingBasket

  def logged_in?(session) do
    Session.logged_in?(session)
  end

  def user_name(session) do
    user = Session.current_customer(session)
    customer_name(user)
  end

  def user_country(session) do
    nil # TODO
  end

  def currency_preference(session) do
    Session.currency_preference(session)
  end

  def user_vat_rate(session) do
    120 # TODO
  end

  # This is the price without vat
  def checkout_price(session) do
    shopping_basket = Session.shopping_basket(session)
    in_pence = ShoppingBasket.payment_gross(shopping_basket)
    user_price(in_pence, session)
  end

  def user_price(pence, session) do
    case currency_preference(session) do
      "GBP" ->
        "£#{pence / 100}"
      "EUR" ->
        "TODO"
      "USD" ->
        "$TODO"
    end
  end

  def number_of_purchases(session) do
    shopping_basket = Session.shopping_basket(session)
    ShoppingBasket.number_of_lines(shopping_basket)
  end

  def user_account_url(session) do
    case Session.current_customer(session) do
      nil -> "/customers/__guest__"
      %{id: id} -> "/customers/#{id}"
    end
  end

  def user_shopping_basket_url(session) do
    case Session.shopping_basket(session).id do
      nil ->
        "/shopping_baskets/__empty__"
      id ->
        "/shopping_baskets/#{id}"
    end
  end

  def current_shopping_basket_id(session) do
    # TODO
    "__empty__"
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
    # UM.Catalogue.Piece.product_name(piece)
    "Oh noes"
  end

  def piece_catalogue_number(piece) do
    UM.Catalogue.Piece.catalogue_number(piece)
  end

  def item_title(_) do
    "TODO"
  end
  def item_sub_heading(_) do
    "TODO"
  end
  def item_name(_) do
    "TODO"
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

  def item_piece_product_name(item) do
    "TODO"
  end

  def cart_discount_code(_cart) do
    "TODO"
  end

  def discount_code(discount) do
    UM.Sales.Discount.code(discount)
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

  def order_checkout_date(_order) do
    # '%d %B %Y'
    "TODO"
  end

  def order_expiry_date(order) do
    "4 days later" # TODO
  end

  def order_payment_gross(order) do
    "TODO"
  end

  def basket_payment_gross(basket) do
    "TODO"
  end

  def basket_free?(basket) do
    ShoppingBasket.free?(basket)
  end

  def order_tax_payment(order) do

  end

  def discount_number_redeemed(discount) do
    0 # TODO
  end

  # def basket_tax_payment(basket, vat) do
  #   in_pence = ShoppingBasket.payment_gross(basket)
  #   # TODO handle vat rate here
  #   user_price(in_pence, session)
  # end

  def order_purchases(order) do
    [%{
      item: %{
        id: "something",
        piece_id: "somethinf else",
        asset: "TODO"

      }
    }]
  end
end
