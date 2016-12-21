# Rename SignUpForm
defmodule UM.Web.Customers.CreateForm do
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

  import UM.Web.FormFields

  def validate(form) do
    validator = %{
      first_name: name(required: true),
      last_name: name(required: true),
      email: email(required: true),
      password: password(required: true),
      password_confirmation: password_confirmation,
      country: country(required: true),
      terms_agreement: WebForm.checkbox(required: true)
    }
    WebForm.validate(validator, form)
  end

end
