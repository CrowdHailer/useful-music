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

  def validate(form) do
    # TODO SQL security
    WebForm.validate(%{
      first_name: {:required, &UM.Web.Customers.CreateForm.validate_name/1},
      last_name: {:required, &UM.Web.Customers.CreateForm.validate_name/1},
      email: {:required, &UM.Web.Customers.CreateForm.validate_email/1},
      country: {:required, fn(x) -> {:ok, x} end},
      question_1: {:optional, fn(x) -> {:ok, x} end},
      question_2: {:optional, fn(x) -> {:ok, x} end},
      question_3: {:optional, fn(x) -> {:ok, x} end},
    }, form)
  end
end
