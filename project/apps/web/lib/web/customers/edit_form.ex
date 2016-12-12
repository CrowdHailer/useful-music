defmodule UM.Web.Customers.EditForm do
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
    WebForm.validate(%{
      first_name: UM.Web.FormFields.name(required: true),
      last_name: UM.Web.FormFields.name(required: true),
      email: UM.Web.FormFields.email(required: true),
      country: {:required, fn(x) -> {:ok, x} end},
      question_1: {:optional, fn(x) -> {:ok, x} end},
      question_2: {:optional, fn(x) -> {:ok, x} end},
      question_3: {:optional, fn(x) -> {:ok, x} end},
    }, form)
  end
end
