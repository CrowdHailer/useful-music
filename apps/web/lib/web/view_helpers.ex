defmodule UM.Web.ViewHelpers do

  ####### ACCOUNTS #######

  def customer_name(customer) do
    # FIXME html escape because outside information
    UM.Accounts.Customer.name(customer)
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

  def item_asset_url(item) do
    UM.Catalogue.ItemStorage.url({item.asset, item}, :original, signed: true)
  end

  ####### SALES #######

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
