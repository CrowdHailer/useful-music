defmodule UM.Sales.Order do
  defstruct [
    :id,
    :customer_id,
    :state,
    :cart_total,
    :tax_payment,
    :discount_value,
    :payment_gross,
    :payment_net,
    :currency,
    :token,
    :payer_email,
    :payer_first_name,
    :payer_last_name,
    :payer_company,
    :payer_status,
    :payer_identifier,
    :transaction_id,
    :completed_at,
    :cart
  ]

  def cart_total(%{currency: currency, cart_total: pence}) do
    {currency, pence}
  end

  def tax_payment%{currency: currency, tax_payment: pence} do
    {currency, pence}
  end

  def discount_value%{currency: currency, discount_value: pence} do
    {currency, pence}
  end

  def payment_net%{currency: currency, payment_net: pence} do
    {currency, pence}
  end
end
