defmodule UM.Sales.Order do
  defstruct [
    :id,
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
    :cart]
  end
