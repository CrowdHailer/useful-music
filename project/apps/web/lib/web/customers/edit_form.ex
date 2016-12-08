defmodule UM.Web.Customers.EditForm do
  # All of these fields are required
  # extra fields are not necessary a problem but might clash with db rows, unlikely
  defstruct [
    first_name: nil,
    last_name: nil,
    email: nil,
    password: nil,
    password_confirmation: nil, # hmmm
    country: nil,
    terms_agreement: nil # hmmm
  ]
end
